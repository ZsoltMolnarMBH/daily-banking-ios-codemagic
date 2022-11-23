//
//  AccountDetailsScreenViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 02..
//

import Resolver
import Combine
import BankAPI

enum AccountDetailsScreenResult {
    case accountDetailsExplanationRequested
    case limitedAccountInfoRequested
    case proxyIdExplanationRequested
    case transactionLimitStartPageRequested
    case packageDetailsRequested
    case accountClosingFlowStartRequested
}

class AccountDetailsScreenViewModel: ScreenViewModel<AccountDetailsScreenResult>,
                                     AccountDetailsScreenViewModelProtocol {
    @Injected private var account: ReadOnly<Account?>
    @Injected private var dashboardConfig: DashboardConfig
    private var disposeBag = Set<AnyCancellable>()
    private var toastSubject = PassthroughSubject<String, Never>()
    var toast: AnyPublisher<String, Never> {
        toastSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        account.publisher
            .map { account -> MoneyViewModel in
                guard let account = account else {
                    return .zeroHUF
                }
                return .make(using: account.availableBalance)
            }
            .assign(to: \.balance, onWeak: self)
            .store(in: &disposeBag)

        account.publisher
            .map { account -> AccountDetailsViewModel in
                guard let account = account else {
                    return .empty
                }

                let lockedBalance = account.blockedBalance.localizedString
                let bookedBalance = account.bookedBalance.localizedString
                let arrearsBalance = account.arrearsBalance.localizedString
                let accountNumber = account.accountNumber.formatted(pattern: .accountNumber)
                let iban = account.iban.formatted(pattern: .iban)
                let swift = account.swift

                return .init(lockedBalance: lockedBalance,
                             bookedBalanced: bookedBalance,
                             arrearsBalance: arrearsBalance,
                             accountNumber: accountNumber,
                             iban: iban,
                             swift: swift)
            }
            .assign(to: \.accountDetails, onWeak: self)
            .store(in: &disposeBag)

        account.publisher
            .compactMap { $0?.isLimited }
            .assign(to: \.isAccountLimited, onWeak: self)
            .store(in: &disposeBag)
    }

    let accountTypeDescription = Strings.Localizable.commonAccountTypeRetailHuf
    @Published var isAccountLimited: Bool = false
    @Published var balance: MoneyViewModel = .zeroHUF
    let balanceInfo = Strings.Localizable.accountDetailsAvailableBalance
    @Published var accountDetails: AccountDetailsViewModel = .empty
    var isAccountClosingEnabled: Bool {
        dashboardConfig.isAccountClosingEnabled
    }

    func handle(event: AccountDetailsScreenInput) {
        switch event {
        case .accountDetailsInfo:
            events.send(.accountDetailsExplanationRequested)
        case .limitedAccountInfo:
            events.send(.limitedAccountInfoRequested)
        case .copyAccountNumber:
            if let accountNumber = account.value?.accountNumber {
                UIPasteboard.general.string = accountNumber
                toastSubject.send(Strings.Localizable.commonAccountNumberCopiedToClipboard)
            }
        case .copyIBAN:
            if let iban = account.value?.iban {
                UIPasteboard.general.string = iban
                toastSubject.send(Strings.Localizable.commonIbanCopiedToClipboard)
            }
        case .proxyIdInfo:
            events.send(.proxyIdExplanationRequested)
        case .accountLimit:
            events.send(.transactionLimitStartPageRequested)
        case .packageDetails:
            events.send(.packageDetailsRequested)
        case .closeAccount:
            events.send(.accountClosingFlowStartRequested)
        }
    }
}

extension AccountDetailsViewModel {
    static let empty: AccountDetailsViewModel = .init(lockedBalance: "",
                                                      bookedBalanced: "",
                                                      arrearsBalance: "",
                                                      accountNumber: "",
                                                      iban: "",
                                                      swift: "")
}
