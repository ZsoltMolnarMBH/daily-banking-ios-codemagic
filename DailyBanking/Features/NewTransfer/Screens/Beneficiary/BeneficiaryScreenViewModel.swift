//
//  BeneficiaryScreenViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 27..
//

import Combine
import DesignKit
import Resolver

struct BeneficiaryScreenResult {
    let benificaryName: String
    let accountNumber: String
    let notice: String?
}

class BeneficiaryScreenViewModel: ScreenViewModel<BeneficiaryScreenResult>, BeneficiaryScreenViewModelProtocol {
    @Injected private var config: NewTransferConfig
    @Injected private var account: ReadOnly<Account?>

    @Published var beneficiaryName: String = ""
    @Published var beneficiaryNameState: ValidationState = .normal
    @Published var accountNumber: String = ""
    @Published var accountNumberState: ValidationState = .normal
    @Published var notice: String = ""
    @Published var noticeState: ValidationState = .normal
    @Published var isFormValid: Bool = false

    override init() {
        super.init()
        $beneficiaryName
            .map { [config] name -> ValidationState in
                guard config.isInlineValidationEnabled else { return .normal }
                if name.isEmpty {
                    return .error(text: Strings.Localizable.newTransferBeneficiaryNameEmptyError)
                }
                if !name.contains(only: .ig2Allowed) {
                    return .error(text: Strings.Localizable.newTransferBeneficiaryNameInvalidCharError)
                }
                return .normal
            }
            .assign(to: &$beneficiaryNameState)
        Publishers.CombineLatest($accountNumber, account.publisher)
            .map { [config] value, account -> ValidationState in
                guard config.isInlineValidationEnabled else { return .normal }
                if value.isEmpty {
                    return .error(text: Strings.Localizable.newTransferAccountNumberEmptyError)
                }
                if value == account?.accountNumber {
                    return .error(text: Strings.Localizable.newTransferBeneficiaryAccountNumberMatchesDebtorError)
                }
                if value.count < 16 || !value.count.isMultiple(of: 8) {
                    return .error(text: Strings.Localizable.newTransferBeneficiaryAccountNumberFormatError)
                }
                return .normal
            }
            .assign(to: &$accountNumberState)
        $notice
            .map { [config] notice -> ValidationState in
                guard config.isInlineValidationEnabled else { return .normal }
                if !notice.contains(only: .ig2Allowed) {
                    return .error(text: Strings.Localizable.newTransferNoticeSpecialCharactersError)
                }
                return .normal
            }
            .assign(to: &$noticeState)
        Publishers.CombineLatest3($beneficiaryNameState, $accountNumberState, $noticeState)
            .map({ (beneficiaryNameState: ValidationState, accountNumberState: ValidationState, noticeState: ValidationState) -> Bool in
                beneficiaryNameState == .normal &&
                accountNumberState == .normal &&
                noticeState == .normal
            })
            .assign(to: &$isFormValid)
    }

    func handle(event: BeneficiaryScreenInput) {
        switch event {
        case .onConfirm:
            events.send(.init(benificaryName: beneficiaryName,
                              accountNumber: accountNumber,
                              notice: notice.isEmpty ? nil : notice))
        }
    }
}
