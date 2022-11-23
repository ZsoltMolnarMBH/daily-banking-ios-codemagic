//
//  BankCardLimitStartPageScreen.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 08..
//

import SwiftUI
import DesignKit

protocol BankCardLimitStartPageScreenViewModelProtocol: ObservableObject {
    func handle(event: BankCardLimitStartPageScreenInput)
}

enum BankCardLimitStartPageScreenInput {
    case creditCardLimit
    case cashWithdrawlLimit
}

struct BankCardLimitStartPageScreen<ViewModel: BankCardLimitStartPageScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .m) {
                CardButton(title: Strings.Localizable.bankCardLimitStartPageCreditCardLimit, image: Image(.bankCard)) {
                    viewModel.handle(event: .creditCardLimit)
                }
                CardButton(title: Strings.Localizable.bankCardLimitStartPageCashWithdrawalLimit, image: Image(.sendMoney)) {
                    viewModel.handle(event: .cashWithdrawlLimit)
                }
            }
            .padding()
        }
        .background(Color.background.secondary)
        .analyticsScreenView("set_limit")
    }
}

struct BankCardLimitStartPageScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardLimitStartPageScreen(viewModel: MockBankCardLimitStartPageScreenViewModel())
    }
}

class MockBankCardLimitStartPageScreenViewModel: BankCardLimitStartPageScreenViewModelProtocol {
    func handle(event: BankCardLimitStartPageScreenInput) {}
}
