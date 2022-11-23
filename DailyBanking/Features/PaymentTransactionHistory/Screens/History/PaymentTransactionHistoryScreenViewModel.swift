//
//  PaymentTransactionHistoryScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 01..
//

import Combine
import Resolver

protocol PaymentTransactionHistoryScreenListener: AnyObject {
    func onRecentTransactionSelected(_ transaction: PaymentTransaction)
}

class PaymentTransactionHistoryScreenViewModel: PaymentTransactionHistoryScreenViewModelProtocol {

    @Injected private var payments: ReadOnly<[PaymentTransaction]>
    @Injected private var paymentTransactionAction: PaymentTransactionAction
    @Injected private var account: ReadOnly<Account?>

    @Published var isLoading: Bool = true
    @Published var sections: [PaymentTransactionSection] = []

    weak var listener: PaymentTransactionHistoryScreenListener?
    private var disposeBag = Set<AnyCancellable>()

    init() {
        payments.publisher
            .dropFirst()
            .map { [weak self] payments in
                guard let self = self else { return [] }
                self.isLoading = false
                return self.convert(payments)
            }
            .assign(to: \.sections, onWeak: self)
            .store(in: &disposeBag)
    }

    private func convert(_ domain: [PaymentTransaction]) -> [PaymentTransactionSection] {
        let mapper = PaymentTransactionViewModelMapper(dateFormatter: {
            UserFacingRelativeDateFormatter.string(from: $0, includeTime: true)
        })
        let grouped = Dictionary(grouping: domain, by: { domain -> String in
            DateFormatter.simple.string(from: domain.createdAt)
        })

        return grouped
            .keys
            .lazy
            .sorted()
            .reversed()
            .compactMap { key in
                guard let items = grouped[key], let date = DateFormatter.simple.date(from: key) else { return nil }
                let sectionTitle = UserFacingRelativeDateFormatter.string(from: date, includeTime: false)
                return PaymentTransactionSection(
                    title: sectionTitle,
                    items: items.map { transaction in
                        mapper.map(
                            transaction,
                            action: { [weak self] in
                                self?.listener?.onRecentTransactionSelected(transaction)
                            }
                        )
                    })
            }
    }

    func handle(_ event: PaymentTransactionHistoryEvent) {
        switch event {
        case .onAppear:
            if let account = account.value {
                paymentTransactionAction.refreshPaymentTransactions(of: account).fireAndForget()
            }
        }
    }
}
