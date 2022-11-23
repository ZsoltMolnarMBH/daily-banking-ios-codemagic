//
//  PaymentTransactionDetailsScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 02..
//

import Combine
import DesignKit
import SwiftUI

protocol PaymentTransactionDetailsScreenViewModelProtocol: ObservableObject {
    var icon: ImageName { get }
    var titleAmount: MoneyViewModel { get }
    var date: String { get }
    var isIncoming: Bool { get }
    var isRejected: Bool { get }
    var name: String { get }
    var accountNumber: String { get }
    var notice: String? { get }
    var amount: String { get }
    var fee: String? { get }
    var statusText: String { get }
    var statusDetail: String? { get }
    var transactionId: String { get }
    var toast: AnyPublisher<String, Never> { get }

    func handle(_ event: PaymentTransactionDetailsScreenInput)
}

enum PaymentTransactionDetailsScreenInput {
    case copyAccountNumber
}

struct PaymentTransactionDetailsScreen<ViewModel: PaymentTransactionDetailsScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack {
                    Color.background.primary
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                    Image(viewModel.icon)
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding(.xl)

                BalanceText(viewModel: viewModel.titleAmount)
                    .if(viewModel.isRejected) { text in
                        text.strikethrough()
                    }
                    .foregroundColor(balanceTextColor)
                    .padding(.bottom, .xs)

                Text(viewModel.date)
                    .textStyle(.body2)
                    .foregroundColor(.text.tertiary)
                    .padding(.bottom, .xl)

                SectionHeader(
                    title: viewModel.isIncoming ?
                        Strings.Localizable.transactionDetailsDebtorDataTitle : Strings.Localizable.transactionDetailsBeneficiaryDataTitle
                ).padding(.bottom, .m)
                SectionCard {
                    VStack(spacing: .xl) {
                        InfoView(title: Strings.Localizable.transactionDetailsNameTitle, text: viewModel.name)
                        Button.init {
                            viewModel.handle(.copyAccountNumber)
                        } label: {
                            HStack {
                                InfoView(
                                    title: Strings.Localizable.transactionDetailsAccountNumberTitle,
                                    text: viewModel.accountNumber
                                )
                                Spacer()
                                Image(.fileCopy)
                                    .foregroundColor(Color.text.tertiary)
                            }
                        }
                    }
                }
                .padding(.bottom, .xxxl)

                SectionHeader(title: Strings.Localizable.transactionDetailsDetailsTitle)
                    .padding(.bottom, .m)
                SectionCard(spacing: .xl) {
                    if !viewModel.isIncoming {
                        InfoView(
                            title: Strings.Localizable.transactionAmount,
                            text: viewModel.amount,
                            subtitle: viewModel.fee
                        )
                        .subtitleColor(.text.tertiary)
                    }
                    InfoView(
                        title: Strings.Localizable.transactionDetailsNoticeTitle,
                        text: viewModel.notice ?? Strings.Localizable.newTransferSummaryNoNoticeGiven
                    )
                    .if(viewModel.notice == nil) {
                        $0.textColor(.text.disabled)
                    }
                }
                .padding(.bottom, .m)
                SectionCard {
                    InfoView(
                        title: Strings.Localizable.transactionDetailsStatusTitle,
                        text: viewModel.statusText,
                        subtitle: viewModel.statusDetail
                    )
                }
                .padding(.bottom, .m)
                SectionCard {
                    InfoView(
                        title: Strings.Localizable.transactionDetailsTransactionIdTitle,
                        text: viewModel.transactionId
                    )
                }
                .padding(.bottom, .m)
            }
            .padding(.horizontal, .m)
        }
        .analyticsScreenView("transaction_details")
        .toast(viewModel.toast)
        .background(Color.background.secondary)
    }

    var balanceTextColor: Color {
        if viewModel.isRejected {
            return .text.disabled
        }
        return viewModel.isIncoming ? .success.highlight : .text.primary
    }
}

private class MockViewModel: PaymentTransactionDetailsScreenViewModelProtocol {
    var icon: ImageName = .giroNeutral
    var titleAmount: MoneyViewModel = .init(amount: "+1 330 000", currency: .init(symbol: "Ft", isPrefix: false))
    var date: String = DateFormatter.userFacingWithTime.string(from: Date())
    var isIncoming: Bool = false
    var isRejected: Bool = false
    var name: String = "John Doe"
    var accountNumber: String = "12341144 - 12312332 - 13123123"
    var notice: String? = "Helló belló"
    var amount = "20000 Ft"
    var fee: String? = "+Tranzakciós díj: 1 Ft"
    var statusText: String = "Folyamatban"
    var statusDetail: String? = "Az összeget már levontuk az elérhető egyenlegéből, de a tranzakció még feldolgozás alatt van."
    var transactionId: String = "FR12387123-2"
    var toast: AnyPublisher<String, Never> = PassthroughSubject().eraseToAnyPublisher()

    func handle(_ event: PaymentTransactionDetailsScreenInput) {}
}

struct PaymentTransactionDetailsScreenPreviews: PreviewProvider {
    static var previews: some View {
        PaymentTransactionDetailsScreen(viewModel: MockViewModel())
    }
}
