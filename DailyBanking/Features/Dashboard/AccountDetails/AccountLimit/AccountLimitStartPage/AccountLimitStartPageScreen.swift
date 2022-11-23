//
//  AccountLimitStartPage.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 21..
//

import SwiftUI
import DesignKit

protocol AccountLimitStartPageScreenViewModelProtocol: ObservableObject {
    var dailyTransferLimitFormatted: String { get }

    func handle(event: AccountLimitStartPageScreenInput)
}

enum AccountLimitStartPageScreenInput {
    case dailyTransferLimit
    case info
}

struct AccountLimitStartPageScreen<ViewModel: AccountLimitStartPageScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .m) {
                CardButton(
                    title: Strings.Localizable.accountTransactionLimitStartPageDailyTransferLimit,
                    subtitle: "\(viewModel.dailyTransferLimitFormatted) Ft",
                    image: Image(.sendMoneyArrow)
                ) {
                    viewModel.handle(event: .dailyTransferLimit)
                }
            }
            .padding()
        }
        .background(Color.background.secondary)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                DesignButton(
                    style: .tertiary,
                    width: .fluid,
                    imageName: DesignKit.ImageName.info,
                    action: {
                        viewModel.handle(event: .info)
                    })
                    .analyticsOverride(contentType: "info icon")
            }
        })
    }
}

struct AccountLimitStartPageScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountLimitStartPageScreen(viewModel: MockAccountLimitStartPageScreenViewModel())
    }
}

class MockAccountLimitStartPageScreenViewModel: AccountLimitStartPageScreenViewModelProtocol {
    var dailyTransferLimitFormatted: String = "500 000"

    func handle(event: AccountLimitStartPageScreenInput) {}
}
