//
//  DashboardScreen.swift
//  app-daily-banking-ios
//
//  Created by Zsombor Szabó on 2021. 09. 07..
//

import SwiftUI
import DesignKit
import Combine

protocol DashboardScreenViewModelProtocol: ObservableObject {
    var firstName: String { get set }
    var initials: String { get set }
    var isLoading: Bool { get }
    var balance: MoneyViewModel { get }
    var emptyState: EmptyStateView.ViewModel? { get }
    var isShowProxyIdEducation: Bool { get }
    var isCardEnabled: Bool { get }
    var paymentTransactions: DashboardTransactionHistorySection.Model { get }
    var toast: AnyPublisher<String, Never> { get }
    func handle(event: DashboardScreenInput)
}

enum DashboardScreenInput {
    case onAppear
    case headerDidPress
    case newTransfer
    case accountDetails
    case cardInfo
    case copyAccountNumber
}

typealias DashboardScreen = DashboardScreenComposite<
    DashboardScreenViewModel,
    ProxyIdListComponentViewModel,
    ScaChallengeListComponentViewModel
>

struct DashboardScreenComposite<ViewModel: DashboardScreenViewModelProtocol,
                                ProxyIdViewModel: ProxyIdListComponentViewModelProtocol,
                                ChallengesViewModel: ScaChallengeListComponentViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel
    @ObservedObject var proxyId: ProxyIdViewModel
    @ObservedObject var scaChallengeVM: ChallengesViewModel

    var body: some View {
        FullHeightScrollView {
            VStack {
                ScaChallengeListComponent(viewModel: scaChallengeVM)
                Card(padding: 0) {
                    VStack {
                        VStack(spacing: .s) {
                            BalanceText(viewModel: viewModel.balance)
                            Text(Strings.Localizable.accountDetailsAvailableBalance)
                            HStack {
                                VerticalButton(text: Strings.Localizable.dashboardButtonSendMoney,
                                               imageName: .sendMoneyArrow,
                                               style: .secondary) {
                                    viewModel.handle(event: .newTransfer)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                                VerticalButton(text: Strings.Localizable.dashboardButtonAccountDetails,
                                               imageName: .wallet,
                                               style: .secondary) {
                                    viewModel.handle(event: .accountDetails)
                                }
                               .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                                VerticalButton(text: Strings.Localizable.dashboardButtonCardDetails,
                                               imageName: .bankCard,
                                               style: .secondary) {
                                    viewModel.handle(event: .cardInfo)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .disabled(!viewModel.isCardEnabled)
                            }
                            .padding(.top, .m)
                        }
                        .padding(.vertical, .xl)
                        .padding(.horizontal, .m)
                        .shimmeringPlaceholder(when: viewModel.isLoading, for: .background.primary)

                        DashboardTransactionHistorySection(
                            model: viewModel.paymentTransactions
                        )
                    }
                }
                .id("balanceCard")
                .padding()

                if viewModel.isShowProxyIdEducation, !viewModel.isLoading {
                    SectionCard {
                        ProxyIdListComponent(viewModel: proxyId)
                    }
                    .padding()
                }

                if let emtpyState = viewModel.emptyState {
                    Group {
                        EmptyStateView(viewModel: emtpyState)
                            .padding(.xxxl)
                        DesignButton(style: .tertiary,
                                     width: .fluid,
                                     size: .large,
                                     title: Strings.Localizable.dashboardTopupCta) {
                            viewModel.handle(event: .copyAccountNumber)
                        }
                    }
                    .shimmeringPlaceholder(when: viewModel.isLoading, for: .background.secondary)
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.handle(event: .onAppear)
        }
        .animation(.default, value: viewModel.isLoading)
        .animation(.default, value: viewModel.emptyState)
        .animation(.default, value: viewModel.paymentTransactions)
        .animation(.default, value: scaChallengeVM.scaChallengeList.count)
        .navigationBarItems(leading:
            Button(
                action: { viewModel.handle(event: .headerDidPress) },
                label: {
                    MonogramView(
                        monogram: viewModel.initials,
                        size: .small
                    )
                }
            )
            .shimmeringPlaceholder(when: viewModel.isLoading, for: .background.secondary)
        )
        .toast(viewModel.toast)
        .background(Color.background.secondary)
        .analyticsScreenView("dashboard")
        .navigationTitle(Strings.Localizable.dashboardWelcomeTitle(viewModel.firstName))
        .scrollTo("balanceCard", onReselect: .dashboard)
    }
}

struct DashboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashboardScreenComposite(
            viewModel: MockDashboardViewModel(),
            proxyId: MockProxyIdListViewModel(),
            scaChallengeVM: MockScaChallengeListComponentViewModel())
    }
}

class MockDashboardViewModel: DashboardScreenViewModelProtocol {

    var scaChallengeList: [ScaChallenge] = []
    var isCardEnabled: Bool = false
    var isShowProxyIdEducation: Bool = true
    var firstName: String = "FirstName"
    var initials: String = "IA"
    let isLoading: Bool = false
    var balance = MoneyViewModel.make(using: Money(value: Decimal( 12345600), currency: "HUF"))
    var emptyState: EmptyStateView.ViewModel? {
        .init(imageName: .topup,
              title: "Töltse fel az egyenlegét!",
              description: "Első lépésként másolja ki a számlaszámát, és utaljon át a számlára egy Önnek tetsző.")
    }
    var paymentTransactions: DashboardTransactionHistorySection.Model = .placeholder
    var toast: AnyPublisher<String, Never> = Empty<String, Never>().eraseToAnyPublisher()

    func handle(event: DashboardScreenInput) {
        //
    }
}
