//
//  PasswordCreationScreenViewModel.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import Combine
import CryptoSwift
import DesignKit
import Foundation
import Resolver

enum PasswordCreationScreenEvent {
    case passwordCreated
    case regNotAllowed
    case regTemporaryBlocked
}

class PasswordCreationScreenViewModel: ScreenViewModel<PasswordCreationScreenEvent>,
                                       PasswordCreationScreenViewModelProtocol {
    @Injected var action: RegisterAction
    @Injected var registrationDraft: ReadOnly<RegistrationDraft>

    @Published var criterias: [Criteria] = []
    @Published var password: String = ""
    @Published var passwordFieldState: ValidationState = .normal
    @Published var resultModel: ResultModel?
    @Published var isLoading: Bool = false
    private var alertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        alertSubject.eraseToAnyPublisher()
    }

    private var disposeBag = Set<AnyCancellable>()

    private let minimumPasswordLength = 8
    private lazy var validators: [(String, PasswordCriteria)] = {[
        (Strings.Localizable.createPasswordRuleLowercase, .lowerCaseLetter),
        (Strings.Localizable.createPasswordRuleUppercase, .upperCaseLetter),
        (Strings.Localizable.createPasswordRuleNumber, .number),
        (Strings.Localizable.createPasswordRuleMinLength(minimumPasswordLength), .length(minimumPasswordLength))
    ]}()

    override init() {
        super.init()
        $password
            .map { [validators] password in
                validators.map { title, validator in
                    Criteria(title: title, fulfilled: validator.isFulfilled(for: password))
                }
            }
            .assign(to: \.criterias, onWeak: self)
            .store(in: &disposeBag)

        $criterias
            .sink(receiveValue: { [weak self] criterias in
                let isFulfilled = criterias.allSatisfy { $0.isFulfilled }
                self?.passwordFieldState = isFulfilled ? .validated : .error(text: Strings.Localizable.createPasswordError)
            })
            .store(in: &disposeBag)
    }

    func handle(action: PasswordCreationScreenInput) {
        switch action {
        case .passwordEntered:
            guard passwordFieldState == .validated else { return }
            sendRegistration()
        }
    }

    private func sendRegistration() {
        guard let phone = registrationDraft.value.phoneNumber,
              let email = registrationDraft.value.email else { return }

        isLoading = true
        let pwHash = password.sha512()
        action.register(
            phoneNumber: phone,
            email: email,
            passwordHash: pwHash
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .finished:
                self?.events.send(.passwordCreated)
            case .failure(let error):
                switch error {
                case .action(let regError):
                    switch regError {
                    case .notAllowed:
                        self?.notAllowed()
                    case .temporaryBlocked(let blockedTime):
                        self?.temporaryBlocked(blockedTime)
                    }
                default:
                    self?.alertSubject.send(.genericError(onRetry: { self?.sendRegistration() }))
                }
            }
        })
        .store(in: &disposeBag)
    }

    private func notAllowed() {
        resultModel = .registerNotAllowed(action: { [weak self] in
            self?.events.send(.regNotAllowed)
        })
    }

    private func temporaryBlocked(_ blockedTime: Int) {
        resultModel = .registerTemporaryBlocked(blockedTime: blockedTime, action: { [weak self] in
            self?.events.send(.regTemporaryBlocked)
        })
    }
}
