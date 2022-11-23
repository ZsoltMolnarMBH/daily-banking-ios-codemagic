//
//  NewTransferSummaryScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 27..
//

import SwiftUI
import DesignKit
import Combine

protocol NewTransferSummaryScreenViewModelProtocol: ObservableObject {
    var details: TransferDetailsViewModel { get }
    var isSendEnabled: Bool { get }
    var sendLabel: String { get }
    var sendHint: String { get }
    var isLoading: Bool { get }
    var alert: AnyPublisher<AlertModel, Never> { get }
    func handle(event: NewTransferSummaryScreenInput)
}

enum NewTransferSummaryScreenInput {
    case confirm
    case trasnferDateInfo
}

struct NewTransferSummaryScreen<ViewModel: NewTransferSummaryScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout(content: {
            VStack(spacing: .m) {
                Image(.bankNeutral)
                    .resizable()
                    .frame(width: 72, height: 72)
                Text(viewModel.details.beneficiaryName)
                    .textStyle(.headings3)
                    .foregroundColor(.text.primary)
                    .multilineTextAlignment(.center)
                Text(viewModel.details.accountNumber)
                    .textStyle(.body1)
                    .foregroundColor(.text.tertiary)
                SectionCard(spacing: .xl) {
                    InfoView(title: Strings.Localizable.newTransferSummaryAmountTitle,
                             text: viewModel.details.money,
                             subtitle: viewModel.details.fee)
                    InfoView(title: Strings.Localizable.newTransferSummaryNoticeTitle,
                             text: viewModel.details.notice ?? Strings.Localizable.newTransferSummaryNoNoticeGiven)
                        .if(viewModel.details.notice == nil) {
                            $0.textColor(.text.disabled)
                        }
                    HStack {
                        InfoView(title: Strings.Localizable.newTransferSummaryTransferDateTitle,
                                 text: viewModel.details.transferDate,
                                 subtitle: viewModel.details.transferType)
                            .subtitleColor(.text.tertiary)
                        Spacer()
                        Button {
                            viewModel.handle(event: .trasnferDateInfo)
                        } label: {
                            Image(.info)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.text.tertiary)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }, floater: {
            DesignButton(title: viewModel.sendLabel) {
                viewModel.handle(event: .confirm)
            }
            .disabled(!viewModel.isSendEnabled)
        })
        .floaterHint(viewModel.sendHint)
        .fullScreenProgress(by: viewModel.isLoading, name: "newtransfersummary")
        .designAlert(viewModel.alert)
        .analyticsScreenView("new_transfer_summary")
    }

    struct CurrencyView: View {
        let currency: CurrencyViewModel
        var body: some View {
            Text(currency.symbol)
                .textStyle(.headings1)
                .foregroundColor(.text.tertiary)
        }
    }
}

struct NewTrasnferSummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewTransferSummaryScreen<NewTrasnferSummaryScreenViewModelMock>(viewModel: .init())
            .preferredColorScheme(.light)
    }
}

class NewTrasnferSummaryScreenViewModelMock: NewTransferSummaryScreenViewModelProtocol {
    let details = TransferDetailsViewModel(beneficiaryName: "Arató Péter",
                                           accountNumber: "12345678 - 12345678 - 12345678",
                                           money: "15 000 Ft",
                                           fee: "+ Tranzakciós díj: 123 Ft",
                                           notice: "Szia Helló!",
                                           transferDate: "2021. augusztus 26.",
                                           transferType: "Azonnali utalás")
    var isSendEnabled = true
    var sendLabel = "Küldés 15 000 Ft"
    var sendHint = "Az átutalás jóváhagyása következik."
    var isLoading = false
    var alert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()
    func handle(event: NewTransferSummaryScreenInput) {
    }
}
