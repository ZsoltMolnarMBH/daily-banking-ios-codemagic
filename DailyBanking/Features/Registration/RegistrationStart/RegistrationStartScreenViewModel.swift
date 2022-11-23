//
//  RegistrationStartScreenViewModel.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import Combine
import Foundation
import Resolver
import DesignKit

enum RegistrationStartScreenEvent {
    case infoProvided(phoneNumber: String, email: String)
    case termsAndConditionsRequested(url: String)
    case privacyPolicyRequested(url: String)
    case phoneInfoRequested
    case emailInfoRequested
}

class RegistrationStartScreenViewModel: ScreenViewModel<RegistrationStartScreenEvent>,
                                        RegistrationStartScreenViewModelProtocol {
    @Injected private var store: any RegistrationDraftStore
    @Injected private var draft: ReadOnly<RegistrationDraft>
    @Injected private var action: RegisterAction

    @Published var phonePrefix: String = "+36"
    @Published var phoneNumber: String = ""
    @Published var email: String = ""
    @Published var isPhoneNumberCapableForRegistration = true
    @Published var fieldsAreValid = false
    @Published var tcAccepted: Bool = false
    @Published var privacyAccepted: Bool = false
    var termsURL: String = "https://ms-onboarding-test.dev.sandbox-mbh.net/static/hozzajarulasi_nyilatkozat_FF_0527.pdf"
    var privacyURL: String = "https://ms-onboarding-test.dev.sandbox-mbh.net/static/data_protection_management_FF_0527.pdf"

    @Published var phoneFieldState: PhoneNumberValidity = .normal
    @Published var emailFieldState: ValidationState = .normal

    private var disposeBag = Set<AnyCancellable>()
    private var verify: Cancellable?

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
                            Just(PhoneNumberValidity.success)
                                .setFailureType(to: Error.self)
                                .eraseToAnyPublisher()
                        )
                        .tryCatch { _ -> AnyPublisher<PhoneNumberValidity, Error> in
                            Just(PhoneNumberValidity.notAllowed)
                                .setFailureType(to: Error.self)
                                .eraseToAnyPublisher()
                        }
                    )
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .replaceError(with: .normal)
            .assign(to: &$phoneFieldState)

        let isEmailCorrectlyFormatted = $email
            .map { $0.matches(pattern: .email) }
        isEmailCorrectlyFormatted
            .map { isCorrectlyFormatted -> ValidationState in
                isCorrectlyFormatted
                    ? .validated
                    : .error(text: Strings.Localizable.commonErrorWrongEmail)
            }
            .assign(to: &$emailFieldState)

        draft.publisher
            .sink { [weak self] draft in
                self?.tcAccepted = draft.isTermsAccepted
                self?.privacyAccepted = draft.isPrivacyAccepted
            }
            .store(in: &disposeBag)

        $tcAccepted
            .removeDuplicates()
            .sink(receiveValue: { [store] isAccepted in
                store.modify {
                    $0.isTermsAccepted = isAccepted
                }
            })
            .store(in: &disposeBag)

        $privacyAccepted
            .removeDuplicates()
            .sink(receiveValue: { [store] isAccepted in
                store.modify {
                    $0.isPrivacyAccepted = isAccepted
                }
            })
            .store(in: &disposeBag)

        Publishers.CombineLatest4(
            $phoneFieldState.map { $0 == .success },
            isEmailCorrectlyFormatted,
            $tcAccepted,
            $privacyAccepted
        )
        .map { (isPhoneValidated: Bool, isEmailValid: Bool, isTcAccepted: Bool, isPrivacyAccepted: Bool) -> Bool in
            isPhoneValidated && isEmailValid && isTcAccepted && isPrivacyAccepted
        }
        .assign(to: &$fieldsAreValid)
    }

    func handle(event: RegistrationStartScreenInput) {
        switch event {
        case .phoneInfoPressed:
            events.send(.phoneInfoRequested)
        case .emailInfoPressed:
            events.send(.emailInfoRequested)
        case .proceed:
            events.send(.infoProvided(
                phoneNumber: phonePrefix + phoneNumber.deformatted(pattern: .phoneNumber),
                email: email)
            )
        case .privacySelected:
            events.send(.privacyPolicyRequested(url: privacyURL))
        case .tcSelected:
            events.send(.termsAndConditionsRequested(url: termsURL))
        }
    }
}
