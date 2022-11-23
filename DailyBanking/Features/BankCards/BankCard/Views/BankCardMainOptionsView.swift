//
//  CardFunctionButtonsView.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import SwiftUI
import DesignKit
import Resolver

struct BankCardMainOptionsView<ViewModel: BankCardScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            VerticalButton(
                text: Strings.Localizable.bankCardDetailsShowMoreDetails,
                imageName: .viewOff,
                style: .secondary
            ) {
                viewModel.handle(.cardInfo)
            }
            .disabled(viewModel.cardState.cardInfoDisabled)
            .frame(maxWidth: .infinity)
            Spacer()
            VerticalButton(
                text: Strings.Localizable.bankCardDetailsShowPinCode,
                imageName: .key,
                style: .secondary
            ) {
                viewModel.handle(.showPin)
            }
            .disabled(viewModel.cardState.pinCodeRevealDisabled)
            .frame(maxWidth: .infinity)
            Spacer()
            VerticalButton(
                text: viewModel.freezeButtonLabel,
                imageName: .freez,
                style: viewModel.freezeButtonStyle
            ) {
                viewModel.handle(.freezeCard)
            }
            .disabled(viewModel.cardState.freezeDisabled)
            .frame(maxWidth: .infinity)
        }
    }
}

struct BankCardMainOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        BankCardMainOptionsView(viewModel: MockBankCardScreenViewModel())
    }
}
