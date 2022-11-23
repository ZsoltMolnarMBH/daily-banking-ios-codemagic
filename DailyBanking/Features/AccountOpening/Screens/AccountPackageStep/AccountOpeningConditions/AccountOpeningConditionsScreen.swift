//
//  AccountOpeningConditionsScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 12. 05..
//

import SwiftUI
import DesignKit

protocol AccountOpeningConditionsScreenViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    func handle(_ event: AccountOpeningConditionsScreenInput)
}

enum AccountOpeningConditionsScreenInput {
    case nextButtonPressed
}

struct AccountOpeningConditionsScreen<ViewModel: AccountOpeningConditionsScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        InfoMarkdownScreen(markdown: Strings.Localizable.accountOpeningConditions)
            .acknowledge(title: Strings.Localizable.commonNext)
            .acknowledge(onAcknowledge: {
                viewModel.handle(.nextButtonPressed)
            })
        .fullScreenProgress(by: viewModel.isLoading, name: "accountopening")
        .analyticsScreenView("oao_account_conditions")
    }
}

struct AccountOpeningConditionsScreenPreview: PreviewProvider {
    static var previews: some View {
        AccountOpeningConditionsScreen(viewModel: MockViewModel())
            .preferredColorScheme(.light)
    }
}

private class MockViewModel: AccountOpeningConditionsScreenViewModelProtocol {
    var isLoading: Bool = false
    func handle(_ event: AccountOpeningConditionsScreenInput) {}
}
