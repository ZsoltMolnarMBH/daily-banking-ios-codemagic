//
//  BankCardReorderScreen.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 24..
//

import SwiftUI
import DesignKit

protocol BankCardReorderViewModelProtocol: ObservableObject {

    var address: String { get set }

    var currency: String { get }

    var deliveryDate: String { get }

    var isLoading: Bool { get set }

    func handle(_ event: BankCardReorderScreenInput)
}

enum BankCardReorderScreenInput {
    case order
    case addressInfo
}

struct BankCardReorderScreen<ViewModel: BankCardReorderViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                Text("Mastercard World Elite")
                    .textStyle(.headings3.thin)
                    .foregroundColor(.text.primary)
                BankCardPlaceholderView(cardNumberLastDigits: "")
                CardInfo(title: Strings.Localizable.bankCardPostingAddress, subtitle: self.viewModel.address) {
                    self.viewModel.handle(.addressInfo)
                }
                SectionCard {
                    InfoView(
                        title: Strings.Localizable.bankCardReorderCost,
                        text: "0 \(viewModel.currency)"
                    )
                }
                SectionCard {
                    InfoView(
                        title: Strings.Localizable.bankCardEstimatedDelivery,
                        text: viewModel.deliveryDate
                    )
                }
            }
            .padding()
            Spacer()
        } floater: {
            DesignButton(
                style: .primary,
                size: .large,
                title: Strings.Localizable.bankCardOrder
            ) {
                viewModel.handle(.order)
            }
        }
        .floaterHint(Strings.Localizable.bankCardNextStepPin)
        .fullScreenProgress(by: viewModel.isLoading)
    }
}

private class MockViewModel: BankCardReorderViewModelProtocol {

    var deliveryDate: String = "2022. feburuár 22."
    var address: String = "Budapest"

    var currency: String = "Ft"

    var isLoading: Bool = false

    func handle(_ event: BankCardReorderScreenInput) {}
}

struct BankCardReorderScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardReorderScreen(viewModel: MockViewModel())
    }
}
