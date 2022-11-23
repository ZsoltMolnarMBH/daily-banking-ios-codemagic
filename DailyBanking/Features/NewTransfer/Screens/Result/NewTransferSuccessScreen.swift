//
//  NewTransferSuccessScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 28..
//

import SwiftUI
import DesignKit

protocol NewTransferSuccessScreenViewModelProtocol: ObservableObject {
    var title: String { get }
    var subtitle: String { get }
    var details: TransferDetailsViewModel { get }
    func handle(event: NewTransferSuccessScreenInput)
}

enum NewTransferSuccessScreenInput {
    case acknowledge
}

struct NewTransferSuccessScreen<ViewModel: NewTransferSuccessScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout(content: {
            VStack(alignment: .center, spacing: .xl) {
                Image(.successSemantic)
                    .resizable()
                    .frame(width: 72, height: 72)
                VStack(spacing: .xs) {
                    Text(viewModel.title)
                        .textStyle(.headings3.thin)
                        .foregroundColor(.text.primary)
                        .multilineTextAlignment(.center)
                    Text(viewModel.subtitle)
                        .textStyle(.body2)
                        .foregroundColor(.text.primary)
                        .multilineTextAlignment(.center)
                }
                DetailsView(details: viewModel.details)
                Spacer()
            }
            .padding()
        }, floater: {
            DesignButton(title: Strings.Localizable.commonAllRight) {
                viewModel.handle(event: .acknowledge)
            }
        })
        .analyticsScreenView("new_transfer_success")
    }

    struct DetailsView: View {
        let details: TransferDetailsViewModel
        var body: some View {
            SectionCard(spacing: .xl) {
                InfoView(title: Strings.Localizable.newTransferResultDetailBeneficiaryTitle,
                         text: details.beneficiaryName,
                         subtitle: details.accountNumber)
                InfoView(title: Strings.Localizable.newTransferResultDetailAmountTitle,
                         text: details.money,
                         subtitle: details.fee)
                InfoView(title: Strings.Localizable.newTransferResultDetailNoticeTitle,
                         text: details.notice ?? Strings.Localizable.newTransferSummaryNoNoticeGiven)
                .if(details.notice == nil) { $0.textColor(.text.disabled) }
                InfoView(title: Strings.Localizable.newTransferSummaryTransferDateTitle,
                         text: details.transferDate,
                         subtitle: details.transferType)
                    .subtitleColor(.text.tertiary)
            }
        }
    }
}

struct NewTrasnferSuccessScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewTransferSuccessScreen<NewTrasnferSuccessScreenViewModelMock>(viewModel: .init())
            .preferredColorScheme(.light)
    }
}

class NewTrasnferSuccessScreenViewModelMock: NewTransferSuccessScreenViewModelProtocol {
    var title = "Az összeg már úton van."
    var subtitle = "Várhatóan pár másodperc múlva megérkezik a kedvezményezetthez."
    let details = TransferDetailsViewModel(beneficiaryName: "Arató Péter",
                                           accountNumber: "12345678 - 12345678 - 12345678",
                                           money: "15 000 Ft",
                                           notice: "Szia Helló!",
                                           transferDate: "2021. augusztus 26.",
                                           transferType: "Azonnali utalás")

    func handle(event: NewTransferSuccessScreenInput) {
    }
}
