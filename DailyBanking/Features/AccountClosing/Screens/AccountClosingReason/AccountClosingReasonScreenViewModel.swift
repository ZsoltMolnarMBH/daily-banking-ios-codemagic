//
//  AccountClosingReasonScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 19..
//

import Foundation
import DesignKit

class AccountClosingReasonScreenViewModel: AccountClosingReasonScreenViewModelProtocol {

    @Published var reasonOptions: RadioButtonOptionSet<AccountClosingDraft.Reason?>
    @Published var comment: String

    var onGoNext: ((_ reason: AccountClosingDraft.Reason?, _ comment: String?) -> Void)?

    init() {
        reasonOptions = .init(
            dataSet: AccountClosingDraft.Reason.allCases.map {
                ($0.displayString, $0)
            },
            selected: .none
        )
        comment = ""
    }

    func handle(event: AccountClosingReasonScreenInput) {
        switch event {
        case .moveNext:
            onGoNext?(reasonOptions.selected, comment.isEmpty ? nil : comment)
        }
    }
}
