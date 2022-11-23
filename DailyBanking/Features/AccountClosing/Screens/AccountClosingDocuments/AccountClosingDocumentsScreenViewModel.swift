//
//  AccountClosingDocumentsScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 23..
//

import Foundation

enum AccountClosingDocumentsScreenResult {
    case contractsRequested
    case monthlyStatementsRequested
}

class AccountClosingDocumentsScreenViewModel: ScreenViewModel<AccountClosingDocumentsScreenResult>,
                                              AccountClosingDocumentsScreenViewModelProtocol {

    var onGoNext: (() -> Void)?
    var onGoBack: (() -> Void)?

    func handle(event: AccountClosingDocumentsScreenInput) {
        switch event {
        case .contracts:
            events.send(.contractsRequested)
        case .monthlyStatements:
            events.send(.monthlyStatementsRequested)
        case .goNext:
            onGoNext?()
        case .goBack:
            onGoBack?()
        }
    }
}
