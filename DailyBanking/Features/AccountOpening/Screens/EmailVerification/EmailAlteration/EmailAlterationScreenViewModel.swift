//
//  AlterEmailScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 04. 24..
//

import Foundation
import Resolver
import Combine
import BankAPI
import DesignKit

protocol EmailAlterationScreenListener: AnyObject {
    func closeRequested()
    func alterEmailSucceeded()
}

class EmailAlterationScreenViewModel: EmailAlterationScreenViewModelProtocol {

    @Published var emailAddress: String = ""
    @Published var emailState: ValidationState = .normal
    @Published var isAlterDisabled: Bool = true
    @Published var errorDisplay: ResultModel?
    @Published var isProcessing: Bool = false

    weak var screenListener: EmailAlterationScreenListener?
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>
    @Injected var applicationAction: ApplicationAction

    private var disposeBag = Set<AnyCancellable>()

    init() {
        emailAddress = accountOpeningDraft.value.individual?.email.address ?? ""

        $emailAddress.dropFirst().sink { [weak self] editingEmail in
            self?.setEmailState(by: editingEmail)
        }.store(in: &disposeBag)
    }

    func handle(event: EmailAlterationScreenInput) {
        isProcessing = true
        switch event {
        case .alterEmail:
            applicationAction.changeEmailAddress(email: emailAddress).sink { [weak self] result in
                self?.isProcessing = false
                if case .failure = result {
                    self?.errorDisplay = .genericError(screenName: "registration_modify_e-mail_error", action: { [weak self] in
                        self?.errorDisplay = nil
                    })
                } else {
                    self?.screenListener?.alterEmailSucceeded()
                }
            } receiveValue: { _ in

            }.store(in: &disposeBag)
        }
    }

    private func setEmailState(by editingEmail: String) {
        guard editingEmail != accountOpeningDraft.value.individual?.email.address else {
            isAlterDisabled = true
            emailState = .error(text: Strings.Localizable.emailAlterationSameEmailNotAllowedError)
            return
        }

        let isValid = editingEmail.matches(pattern: .email)
        if isValid {
            emailState = .normal
        } else {
            emailState = .error(text: Strings.Localizable.commonErrorWrongEmail)
        }

        isAlterDisabled = !isValid
    }
}
