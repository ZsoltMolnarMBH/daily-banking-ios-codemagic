//
//  RegistrationOTPViewModel.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 29..
//

import Combine
import Foundation
import QuartzCore
import Resolver
import DesignKit

enum RegistrationOTPScreenEvent {
    case otpVerified
    case restartRegistrationRequested
}

class RegistrationOTPScreenViewModel: ScreenViewModel<RegistrationOTPScreenEvent>,
                                      RegistrationOTPScreenViewModelProtocol {
    @Injected var action: RegisterAction
    @Injected var registrationDraft: ReadOnly<RegistrationDraft>

    @Published var smsOTP: String = ""
    @Published var smsFieldState: ValidationState = .normal
    @Published var expiration: TimeInterval = 0
    @Published var responseTime: Date = Date()
    @Published var phoneNumber: String = ""
    @Published var isCodeExpired: Bool = false
    @Published var requestingSMS: Bool = false
    @Published var codeExpirationRemaining: CountDownTimer.TimeRemaining = .zero
    @Published var smsTimeRemaining: CountDownTimer.TimeRemaining = .zero
    @Published var resultModel: ResultModel?
    private var alertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        alertSubject.eraseToAnyPublisher()
    }
    private var toastSubject = PassthroughSubject<String, Never>()
    var toast: AnyPublisher<String, Never> {
        toastSubject.eraseToAnyPublisher()
    }

    private var disposeBag = Set<AnyCancellable>()
    private var countDownTimers = Set<AnyCancellable>()

    override init() {
        super.init()
        $smsOTP
            .removeDuplicates()
            .map { [unowned self] otp -> AnyPublisher<ValidationState, Never> in
                // If the entered/copied number is not 6 didgits long,
                // we hate to cancel any previous communication
                guard String(otp.prefix(6)).count == 6 else {
                    return Just(ValidationState.normal)
                        .eraseToAnyPublisher()
                }

                return Just(ValidationState.loading)
                    .eraseToAnyPublisher()
                    .append(self.action
                        .verifyOTP(otp: otp)
                        .setOutputType(to: ValidationState.self)
                        .append(
                            Just(ValidationState.validated)
                                .setFailureType(to: ActionError<VerifyOtpError>.self)
                                .eraseToAnyPublisher()
                        )
                        .catch { [weak self] error -> AnyPublisher<ValidationState, Never> in
                            let errorMessage: String
                            switch error {
                            case .action(let actionError):
                                switch actionError {
                                case .tooManyTry:
                                    errorMessage = Strings.Localizable.registrationOtpErrorTooManyOtpTrySubtitle
                                    self?.tooManyWrongOtp()
                                case .wrongOtp(remainingAttempts: let remaining):
                                    errorMessage = Strings.Localizable.registrationOtpErrorWrongOtp(remaining)
                                case .expired:
                                    errorMessage = Strings.Localizable.registrationOtpErrorOtpExpired
                                }
                            default:
                                errorMessage = Strings.Localizable.commonGenericErrorRetry
                            }
                            return Just(ValidationState.error(text: errorMessage))
                                .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                    )
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
            .assign(to: &$smsFieldState)

        $smsFieldState
            .sink { [weak self] state in
                if state == .validated {
                    self?.events.send(.otpVerified)
                }
            }
            .store(in: &disposeBag)

        registrationDraft
            .publisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] draft in
                self?.draftDidChange(draft)
            }
            .store(in: &disposeBag)

        $codeExpirationRemaining
            .dropFirst()
            .map { $0.total }
            .removeDuplicates()
            .sink(receiveValue: { [weak self] total in
                if total == 0 {
                    self?.expiredCode()
                }
            })
            .store(in: &disposeBag)

        draftDidChange(registrationDraft.value)
    }

    func handle(_ event: RegistrationOTPScreenInput) {
        guard smsTimeRemaining.total == 0 else { return }
        switch event {
        case .resendOtp:
            resendOtp()
        }
    }

    private func resendOtp() {
        guard let phone = registrationDraft.value.phoneNumber else { return }
        requestingSMS = true
        action
            .resendOtp(phoneNumber: phone)
            .sink(receiveCompletion: { [weak self, toastSubject, registrationDraft] completion in
                self?.requestingSMS = false
                switch completion {
                case .finished:
                    if let remaining = registrationDraft.value.smsOtpInfo?.remainingResendAttempts {
                        toastSubject.send(Strings.Localizable.registrationOtpNewCodeSent(remaining))
                    }
                    self?.smsOTP = ""
                    self?.smsFieldState = .normal
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        switch actionError {
                        case .tooManyRequests:
                            self?.tooManyResendRequest()
                        case .tooSoonRequest:
                            self?.alertSubject.send(.genericError {})
                        }
                    default:
                        self?.alertSubject.send(.genericError { self?.resendOtp() })
                    }
                }
            })
            .store(in: &disposeBag)
    }

    private func draftDidChange(_ draft: RegistrationDraft) {
        if let phone = registrationDraft.value.phoneNumber {
           phoneNumber = phone.formatted(pattern: .phoneNumberWithCountryCode)
        }
        countDownTimers.removeAll()

        if let otpInfo = draft.smsOtpInfo, !otpInfo.isExpired {
            responseTime = otpInfo.responseTime
            expiration = otpInfo.expireTime.timeIntervalSince(responseTime)
            startTimers(otpInfo.nextRequestTime, responseTime: responseTime, expiration: expiration)
        } else {
            expiredCode()
        }
    }

    private func startTimers(_ nextRequestTime: Date, responseTime: Date, expiration: TimeInterval) {
        CountDownTimer(duration: nextRequestTime.timeIntervalSinceNow)
            .assign(to: \.smsTimeRemaining, onWeak: self)
            .store(in: &countDownTimers)

        CountDownTimer(duration: responseTime.addingTimeInterval(expiration).timeIntervalSince(Date()))
            .assign(to: \.codeExpirationRemaining, onWeak: self)
            .store(in: &countDownTimers)
    }

    private func expiredCode() {
        resultModel = .expiredCode(
            phoneNumber: phoneNumber,
            primaryAction: { [weak self] in
                self?.resultModel = nil
                self?.handle(.resendOtp)
            }, secondaryAction: { [weak self] in
                self?.events.send(.restartRegistrationRequested)
            })
    }

    private func tooManyResendRequest() {
        resultModel = .otpBlocked(action: { [weak self] in
            self?.events.send(.restartRegistrationRequested)
        })
    }

    private func tooManyWrongOtp() {
        resultModel = .tooManyWrongOtp(
            phoneNumber: phoneNumber,
            primaryAction: { [weak self] in
                self?.resultModel = nil
                self?.handle(.resendOtp)
            }, secondaryAction: { [weak self] in
                self?.events.send(.restartRegistrationRequested)
            }
        )
    }
}

private extension RegistrationDraft.OtpInfo {
    var isExpired: Bool {
        Date() > expireTime
    }
}
