//
//  Result+AccountCreationFailed.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 25..
//

import Foundation

extension ResultModel {
    static func accountCreationFailed() -> ResultModel {
        .init(
            icon: .failure,
            title: Strings.Localizable.commonGenericErrorTitle,
            subtitle: Strings.Localizable.commonGenericErrorContactUs,
            primaryAction: .init(
                title: Strings.Localizable.commonHelpRequest,
                action: {
                    ActionSheetView(.contactsAndHelp).show()
                }
            ),
            analyticsScreenView: "oao_present_contract_error_ask_for_help"
        )
    }
}
