//
//  DashboardHeaderViewModel.swift
//  app-daily-banking-ios
//
//  Created by Zsombor Szabó on 2021. 09. 21..
//

import Foundation
import Combine
import Resolver
import DesignKit

enum DashboardScreenResult {
    case headerSelected
    case newTransferRequested
    case accountDetailsRequested
    case cardInfoRequested
    case recentTransactionSelected(_ transaction: PaymentTransaction)
}

final class DashboardScreenViewModel: ScreenViewModel<DashboardScreenResult>, DashboardScreenViewModelProtocol {
    @Injected private var account: ReadOnly<Account?>
    @Injected private var user: ReadOnly<User?>
    @Injected private var payments: ReadOnly<[PaymentTransaction]>
    @Injected private var accountAction: AccountAction
    @Injected private var paymentTransactionAction: PaymentTransactionAction
    @Injected private var appConfig: AppConfig

    @Published var firstName: String = ""
    @Published var initials = ""
    @Published var isLoading: Bool = true
    @Published var balance: MoneyViewModel = .zeroHUF
    @Published var emptyState: EmptyStateView.ViewModel?
    @Published var isShowProxyIdEducation: Bool = false
    @Published var isCardEnabled: Bool = false
    @Published var paymentTransactions: DashboardTransactionHistorySection.Model = .placeholder

    private var toastSubject = PassthroughSubject<String, Never>()
    var toast: AnyPublisher<String, Never> {
        toastSubject.eraseToAnyPublisher()
    }

    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        isCardEnabled = appConfig.general.bankCardEnabled

        user.publisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] (user: User) in
                self?.firstName = user.name.firstName
                self?.initials = user.name.initials
            }
            .store(in: &disposeBag)

        account.publisher
            .sink { [weak self] account in
                guard let self = self else { return }
                guard let account = account else { return }
                let balance = account.availableBalance
                self.balance = .make(using: balance)
            }
            .store(in: &disposeBag)

        account.publisher
            .map { $0 == nil }
            .assign(to: \.isLoading, onWeak: self)
            .store(in: &disposeBag)

        account.publisher
            .compactMap { $0 }
            .sink(receiveValue: { [paymentTransactionAction] account in
                paymentTransactionAction.refreshPaymentTransactions(of: account).fireAndForget()
            })
            .store(in: &disposeBag)

        let hasTransactionsPublisher = payments.publisher
            .dropFirst()
            .map { $0.count > 0 }

        account.publisher
            .compactMap { $0 }
            .map { $0.availableBalance.value != 0 }
            .combineLatest(hasTransactionsPublisher)
            .sink { [weak self] hasMoney, hasTransactions in
                if hasMoney || hasTransactions {
                    self?.emptyState = nil
                } else {
                    self?.emptyState = .init(
                        imageName: .topup,
                        title: Strings.Localizable.dashboardTopupTitle,
                        description: Strings.Localizable.dashboardTopupDescription)
                }
            }
            .store(in: &disposeBag)

        account.publisher
            .compactMap { $0 }
            .map { account in
                account.proxyIds.count == 0 && account.availableBalance.value > 0
            }
            .assign(to: \.isShowProxyIdEducation, onWeak: self)
            .store(in: &disposeBag)

        payments.publisher
            .dropFirst()
            .map { Array($0.prefix(3)) }
            .map { [weak self] domain -> DashboardTransactionHistorySection.Model in
                guard let self = self else { return .items([]) }
                return .items(self.convert(domain))
            }
            .assign(to: \.paymentTransactions, onWeak: self)
            .store(in: &disposeBag)
    }

    func convert(_ transactions: [PaymentTransaction]) -> [PaymentTransactionItemVM] {
        let mapper = PaymentTransactionViewModelMapper(dateFormatter: {
            UserFacingRelativeDateFormatter.string(from: $0, includeTime: true)
        })
        return transactions.map { transaction in
            mapper.map(
                transaction,
                action: { [weak self] in
                    self?.events.send(.recentTransactionSelected(transaction))
                }
            )
        }
    }

    func handle(event: DashboardScreenInput) {
        switch event {
        case .onAppear:
            accountAction.refreshAccounts().fireAndForget()
        case .headerDidPress:
            events.send(.headerSelected)
        case .newTransfer:
            events.send(.newTransferRequested)
        case .accountDetails:
            events.send(.accountDetailsRequested)
        case .cardInfo:
            events.send(.cardInfoRequested)
        case .copyAccountNumber:
            if let accountNumber = account.value?.accountNumber {
                UIPasteboard.general.string = accountNumber
                toastSubject.send(Strings.Localizable.commonAccountNumberCopiedToClipboard)
            }
        }
    }
}
