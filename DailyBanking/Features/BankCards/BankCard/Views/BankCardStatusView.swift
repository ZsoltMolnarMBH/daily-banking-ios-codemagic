//
//  BankCardStatusView.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 25..
//

import SwiftUI
import DesignKit

struct BankCardStatusView<ViewModel: BankCardScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    let image: Image
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: .xl) {
            image
                .resizable()
                .frame(width: 72, height: 72)
            VStack(spacing: .s) {
                Text(title)
                    .multilineTextAlignment(.center)
                    .textStyle(.headings3.thin)
                    .foregroundColor(.text.primary)
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .textStyle(.body1)
                    .foregroundColor(.text.secondary)
            }
            DesignButton(style: .tertiary, title: Strings.Localizable.commonHelpRequest) {
                viewModel.handle(.help)
            }
        }
        .padding()
    }
}

struct BankCardStatusView_Previews: PreviewProvider {
    static var previews: some View {
        BankCardStatusView(
            viewModel: MockBankCardScreenViewModel(),
            image: Image(.stopwatchSuccess),
            title: "Hello ez itt egy status view.",
            subtitle: "Ez megy egy hatalmas lorem ipsum, ami nagyon uncsi és több sorban helyezkedik el. Köszönöm a figyelmet")
    }
}
