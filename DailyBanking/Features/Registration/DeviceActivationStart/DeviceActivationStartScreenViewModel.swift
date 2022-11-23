//
//  DeviceActivationStartScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 29..
//

import Combine
import CryptoSwift
import DesignKit
import Resolver
import Apollo

enum DeviceActivationStartScreenEvent {
    case helpRequested
    case deviceActivationStarted(phoneNumber: String)
}

class DeviceActivationStartScreenViewModel: ScreenViewModel<DeviceActivationStartScreenEvent>,
                                            DeviceActivationStartScreenViewModelProtocol {
    @Injected private var action: RegisterAction

    let phonePrefix = "+36"
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var phoneFieldState: PhoneNumberValidity = .normal
    @Published var passwordFieldState: ValidationState = .normal
    @Published var isPhoneNumberCapableForActivation = true
    @Published var fieldsAreValid: Bool = false
    @Published var activationErrorMessage: AttributedString?
    @Published var isLoading = false
    @Published var isBlocked = false
    @Published var permamentBlockedModel: ResultModel?
    private var _bottomAlert = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        _bottomAlert.eraseToAnyPublisher()
    }

    private var disposeBag = Set<AnyCancellable>()
    private let phoneFieldError = ValidationState
        .error(text: Strings.Localizable.commonErrorWrongNumber)

    override init() {
        super.init()
        $phoneNumber
            .map {
                $0.deformatted(pattern: .phoneNumber)
            }
            .removeDuplicates()
            .map { [action, phonePrefix] phoneNumber -> AnyPublisher<PhoneNumberValidity, Error> in
                guard PhoneNumberValidator().isValid(phoneNumber: phoneNumber) else {
                    return Just(PhoneNumberValidity.badFormat)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }

                return Just(PhoneNumberValidity.loading)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                    .append(action
                        .verify(phoneNumber: phonePrefix + phoneNumber.deformatted(pattern: .phoneNumber))
                        .mapError { $0 as Error }
                        .setOutputType(to: PhoneNumberValidity.self)
                        .append(
                            Just(PhoneNumberValidity.notAllowed)
                                .setFailureType(to: Error.self)
                                .eraseToAnyPublisher()
                        )
                        .tryCatch { _ -> AnyPublisher<PhoneNumberValidity, Error> in
                            Just(PhoneNumberValidity.normal)
                                .setFailureType(to: Error.self)
                                .eraseToAnyPublisher()
                        }
                    )
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .replaceError(with: .normal)
            .assign(to: &$phoneFieldState)

        $phoneFieldState
            .map { state in
                state != .notAllowed
            }
            .assign(to: &$isPhoneNumberCapableForActivation)

        Publishers.CombineLatest3(
            $phoneFieldState,
            $phoneNumber,
            $password
        )
        .map { (phoneState: PhoneNumberValidity, phone: String, password: String) -> Bool in
            let validPhone = PhoneNumberValidator().isValid(phoneNumber: phone.deformatted(pattern: .phoneNumber))
            return phoneState == .normal && validPhone && password.count > 0
        }
        .assign(to: &$fieldsAreValid)
    }

    func handle(event: DeviceActivationScreenInput) {
        switch event {
        case .startDeviceActivation:
            startDeviceActivation()
        case .help:
            events.send(.helpRequested)
        }
    }

    private func startDeviceActivation() {
        isLoading = true
        activationErrorMessage = nil
        let fullPhone = phonePrefix + phoneNumber.deformatted(pattern: .phoneNumber)
        action.activateDevice(
            phoneNumber: fullPhone,
            passwordHash: password.sha512()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .finished:
                self?.events.send(.deviceActivationStarted(phoneNumber: fullPhone))
            case .failure(let error):
                if case .action(let authError) = error {
                    self?.showAuthError(authError)
                } else {
                    self?.showGenericError()
                }
            }
        }
        .store(in: &disposeBag)
    }

    private func showAuthError(_ error: DeviceActivationError) {
        switch error {
        case .unauthorized(let remaining):
            activationErrorMessage = AttributedString(Strings.Localizable.deviceActivationAuthenticationErrorIos(remaining))
        case .temporaryBlocked(let blockedTime):
            _bottomAlert.send(.temporaryBlocked(time: blockedTime))
            startTemporaryBlockCoolDown(minutes: blockedTime)
        case .blocked:
            isBlocked = true
            permamentBlockedModel = .permamentBlocked { [weak self] in
                self?.events.send(.helpRequested)
            }
        }
    }

    private func showGenericError() {
        activationErrorMessage = AttributedString(Strings.Localizable.commonGenericErrorRetry)
    }

    private func startTemporaryBlockCoolDown(minutes: Int) {
        isBlocked = true
        CountDownTimer(duration: Double(minutes * 60))
            .sink(receiveCompletion: { [weak self] _ in
                self?.isBlocked = false
                self?.activationErrorMessage = nil
            }, receiveValue: { [weak self] time in
                let message = Strings.Localizable.commonErrorRetryAfterIos(time.localized)
                self?.activationErrorMessage = try? AttributedString(markdown: message)
            })
            .store(in: &disposeBag)
    }
}
