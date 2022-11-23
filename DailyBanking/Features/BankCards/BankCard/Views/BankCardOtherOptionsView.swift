//
//  CardBottomButtons.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import SwiftUI
import DesignKit

struct BankCardOtherOptionsView<ViewModel: BankCardScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .xs) {
            HStack {
                Text(Strings.Localizable.bankCardDetailsOtherOptions)
                    .textStyle(.headings5)
                    .foregroundColor(.text.tertiary)
                Spacer()
            }
            .padding(.bottom, .xxs)
            CardButton(
                title: Strings.Localizable.bankCardDetailsDisableCard,
                image: Image(DesignKit.ImageName.remove),
                style: .destructive,
                supplementaryImage: Image(.chevronRight)) {
                    viewModel.handle(.blockCard)
                }
            CardButton(
                title: Strings.Localizable.bankCardDetailsSetLimits,
                image: Image(.limit),
                supplementaryImage: Image(.chevronRight)
            ) {
                viewModel.handle(.cardLimit)
            }
            CardButton(
                title: Strings.Localizable.bankCardDetailsOnlineSecuritySettings,
                image: Image(.filter),
                supplementaryImage: Image(.chevronRight)) { }
        }
        .padding(.top, .xxxl)
    }
}

struct BankCardOtherOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        BankCardOtherOptionsView(viewModel: MockBankCardScreenViewModel())
    }
}
