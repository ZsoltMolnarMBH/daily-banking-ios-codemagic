//
//  AccountOpeningStartPageScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 30..
//

import SwiftUI
import DesignKit

protocol AccountOpeningStartPageScreenViewModelProtocol: ObservableObject {
    func handle(_ event: AccountOpeningStartPageScreenInput)
}

enum AccountOpeningStartPageScreenInput {
    case nextButtonPressed
}

struct AccountOpeningStartPageScreen<ViewModel: AccountOpeningStartPageScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        InfoScreen(model: .init(
            image: .walletDuotone,
            title: Strings.Localizable.accountOpeningStartPageTitle,
            message: Strings.Localizable.accountOpeningStartPageDescription,
            button: .init(
                text: Strings.Localizable.commonNext,
                style: .primary,
                action: { viewModel.handle(.nextButtonPressed) })))
        .background(Color.background.secondary)
        .analyticsScreenView("oao_progress_overview")
    }
}

struct AccountOpeningStartPageScreenPreview: PreviewProvider {
    static var previews: some View {
        AccountOpeningStartPageScreen(viewModel: MockViewModel())
            .preferredColorScheme(.light)
    }
}

private class MockViewModel: AccountOpeningStartPageScreenViewModelProtocol {
    func handle(_ event: AccountOpeningStartPageScreenInput) {}
}
