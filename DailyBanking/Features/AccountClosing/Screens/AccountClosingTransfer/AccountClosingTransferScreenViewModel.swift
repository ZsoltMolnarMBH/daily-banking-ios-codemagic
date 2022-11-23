//
//  AccountClosingTransferScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 24..
//

import Foundation
import DesignKit
import Resolver

class AccountClosingTransferScreenViewModel: AccountClosingTransferScreenViewModelProtocol {

    @Published var accountNumber: String = ""
    @Published var accountNumberState: ValidationState = .normal

    var onGoNext: ((_ transferAccount: String) -> Void)?
    var onGoBack: (() -> Void)?

    init() {
        $accountNumber
            .map { value -> ValidationState in
                if value.count < 16 || !value.count.isMultiple(of: 8) {
                    return .error(text: Strings.Localizable.newTransferBeneficiaryAccountNumberFormatError)
                }
                return .normal
            }
            .assign(to: &$accountNumberState)
    }

    func handle(event: AccountClosingTransferScreenInput) {
        switch event {
        case .goNext:
            onGoNext?(accountNumber)
        case .goBack:
            onGoBack?()
        }
    }
}
