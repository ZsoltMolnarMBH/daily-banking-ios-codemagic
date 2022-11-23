//
//  AccountDetailsScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 02..
//

import SwiftUI
import DesignKit
import Combine

protocol AccountDetailsScreenViewModelProtocol: ObservableObject {
    var accountTypeDescription: String { get }
    var isAccountLimited: Bool { get }
    var balance: MoneyViewModel { get }
    var balanceInfo: String { get }
    var accountDetails: AccountDetailsViewModel { get }
    var toast: AnyPublisher<String, Never> { get }
    var isAccountClosingEnabled: Bool { get }
    func handle(event: AccountDetailsScreenInput)
}

enum AccountDetailsScreenInput {
    case accountDetailsInfo
    case limitedAccountInfo
    case copyAccountNumber
    case copyIBAN
    case proxyIdInfo
    case accountLimit
    case packageDetails
    case closeAccount
}

struct AccountDetailsViewModel {
    let lockedBalance: String
    let bookedBalanced: String
    let arrearsBalance: String
    let accountNumber: String
    let iban: String
    let swift: String
}

typealias AccountDetailsScreen = AccountDetailsScreenComposite<AccountDetailsScreenViewModel,
                                                               ProxyIdListComponentViewModel>

struct AccountDetailsScreenComposite<ViewModel: AccountDetailsScreenViewModelProtocol,
                                     ProxyIdViewModel: ProxyIdListComponentViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var proxyId: ProxyIdViewModel

    var body: some View {
        FullHeightScrollView {
            VStack(spacing: 0) {
                Image(.walletDuotone)
                    .resizable()
                    .frame(width: 72, height: 72)
                Text(viewModel.accountTypeDescription)
                    .textStyle(.headings3.thin)
                    .padding(.xs)
                if viewModel.isAccountLimited {
                    HStack(spacing: .xxs) {
                        ChipView(
                            text: Strings.Localizable.commonLimitedAccount,
                            backgroundColor: .highlight.tertiary,
                            textColor: .background.primaryPressed,
                            size: .large
                        )
                        Button {
                            analytics.logButtonPress(contentType: "info icon", componentLabel: nil)
                            viewModel.handle(event: .limitedAccountInfo)
                        } label: {
                            Image(.info)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.text.tertiary)
                        }
                    }
                    .padding(.top, .xs)
                    .padding(.bottom, .xl)
                }
                BalanceText(viewModel: viewModel.balance)
                Text(viewModel.balanceInfo)
            }
            .padding(.l)
            SectionHeader(title: Strings.Localizable.accountDetailsInfoScreenTitle,
                          button: .init(image: .info, action: {
                viewModel.handle(event: .accountDetailsInfo)
            }))
            SectionCard {
                VStack(spacing: .xl) {
                    InfoView(
                        title: Strings.Localizable.accountDetailsInfoBlockedBalanceTitle,
                        text: viewModel.accountDetails.lockedBalance
                    )
                    InfoView(
                        title: Strings.Localizable.accountDetailsInfoBookedBalanceTitle,
                        text: viewModel.accountDetails.bookedBalanced
                    )
                    InfoView(
                        title: Strings.Localizable.accountDetailsInfoArrearsTitle,
                        text: viewModel.accountDetails.arrearsBalance
                    )
                    Button.init {
                        viewModel.handle(event: .copyAccountNumber)
                    } label: {
                        HStack {
                            InfoView(
                                title: Strings.Localizable.accountDetailsLabelAccountNumber,
                                text: viewModel.accountDetails.accountNumber
                            )
                            Spacer()
                            Image(.fileCopy)
                                .foregroundColor(Color.text.tertiary)
                        }
                    }
                    Button.init {
                        viewModel.handle(event: .copyIBAN)
                    } label: {
                        HStack {
                            InfoView(
                                title: Strings.Localizable.accountDetailsLabelIban,
                                text: viewModel.accountDetails.iban
                            )
                            Spacer()
                            Image(.fileCopy)
                                .foregroundColor(Color.text.tertiary)
                        }
                    }
                    InfoView(
                        title: Strings.Localizable.accountDetailsLabelSwift,
                        text: viewModel.accountDetails.swift
                    )
                }
                .padding(0)
            }
            .padding(.bottom, .xs)
            CardButton(
                title: Strings.Localizable.accountPackageDetailsTitle,
                image: Image(DesignKit.ImageName.fileDocument),
                style: .primary,
                action: {
                    viewModel.handle(event: .packageDetails)
                })
            .padding([.bottom], .xxxl)
            SectionHeader(title: Strings.Localizable.accountDetailsSecondaryAccountId,
                          button: .init(image: .info, action: {
                viewModel.handle(event: .proxyIdInfo)
            }))
            SectionCard {
                ProxyIdListComponent(viewModel: proxyId)
            }
            .padding([.bottom], .xxxl)
            SectionHeader(title: Strings.Localizable.accountDetailsTransactionLimitTitle)
            VStack {
                CardButton(title: Strings.Localizable.accountDetailsTransactionLimitSetLimits, image: Image(.limit)) {
                    viewModel.handle(event: .accountLimit)
                }
                if viewModel.isAccountClosingEnabled {
                    CardButton(
                        title: Strings.Localizable.accountClosingTitle,
                        image: Image(.alert),
                        style: .destructive
                    ) {
                        viewModel.handle(event: .closeAccount)
                    }
                }
            }
            Spacer()
        }
        .toast(viewModel.toast)
        .padding(.horizontal)
        .background(Color.background.secondary)
        .analyticsScreenView("account_details")
    }
}

struct AccountDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsScreenComposite(viewModel: MockAccountDetailsViewModel(), proxyId: MockProxyIdListViewModel())
            .preferredColorScheme(.light)
    }
}

class MockAccountDetailsViewModel: AccountDetailsScreenViewModelProtocol {
    var isAccountClosingEnabled: Bool = true
    let accountTypeDescription = "Lakossági forint számla"
    let isAccountLimited: Bool = true
    let balance = MoneyViewModel(amount: "123456789", currency: .init(symbol: "Ft", isPrefix: false))
    let balanceInfo = "Elérhető egyenleg"
    let accountDetails = AccountDetailsViewModel(lockedBalance: "131 000 Ft",
                                                 bookedBalanced: "1 183 000 Ft",
                                                 arrearsBalance: "17 500 Ft",
                                                 accountNumber: "12345678-12345678-12345678",
                                                 iban: "HU70 12345678-12345678-12345678",
                                                 swift: "MKKBHUHB")
    var toast: AnyPublisher<String, Never> = Empty<String, Never>().eraseToAnyPublisher()
    func handle(event: AccountDetailsScreenInput) {
        // Mock implementation, nothing to do here
    }
}
