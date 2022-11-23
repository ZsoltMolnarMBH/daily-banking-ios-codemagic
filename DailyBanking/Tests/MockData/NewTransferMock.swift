//
//  NewTransferMock.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 21..
//

@testable import DailyBanking
import BankAPI

extension NewTransferDraft {
    static let mock = Mock()
    struct Mock { }
}

extension NewTransferDraft.Mock {
    var lunchWithPeter: NewTransferDraft {
        .init(beneficiary: .init(name: "Peter", accountNumber: "111111112222222233333333"),
              money: .init(value: 1277, currency: "HUF"),
              notice: "Thanks for lunch")
    }
}

extension PaymentTransactionFragment {
    static let mock = Mock()
    struct Mock { }
    func modify(_ transform: @escaping (inout PaymentTransactionFragment) -> Void) -> PaymentTransactionFragment {
        var copy = self
        transform(&copy)
        return copy
    }
}

class NewTransferConfigMock: NewTransferConfig {
    var pollCount: Int = 10
    var pollingInterval: Double = 0.1
    var feeFetchDebounceTime: Double = 0.5
    var isInlineValidationEnabled: Bool = true
}

extension PaymentTransactionFragment.Mock {
    func lunchWithPeter(status: PaymentTransactionStatus = .completed, rejectReason: RejectionReason? = nil) -> PaymentTransactionFragment {
        .init(money: .init(
            amount: "1277",
            currencyCode: "HUF"),
              debtor: PaymentTransactionFragment.Debtor(unsafeResultMap: ParticipantFragment.makeDebtor(
                name: "",
                account: ParticipantFragment.Account(identificationType: .bban,
                                                     identification: "")
              ).resultMap),
              creditor: PaymentTransactionFragment.Creditor(unsafeResultMap: ParticipantFragment.makeCreditor(
                name: "111111112222222233333333",
                account: ParticipantFragment.Account(identificationType: .bban, identification: "123")
              ).resultMap),
              paymentReference: "Thanks for lunch",
              direction: .outgoing,
              status: status,
              id: "asd",
              createdAt: BankAPI.dateFormatter.string(from: Date()),
              rejectionReason: rejectReason)
    }
}

extension PaymentTransactionFragment {
    var wrappedGetPaymentTransactionsQuery: GetPaymentTransactionsQuery.Data {
        var fragments = GetPaymentTransactionsQuery.Data.GetPaymentTransaction.Fragments(unsafeResultMap: .init())
        fragments.paymentTransactionFragment = self
        var query = GetPaymentTransactionsQuery.Data.GetPaymentTransaction(unsafeResultMap: .init())
        query.fragments = fragments
        return GetPaymentTransactionsQuery.Data(getPaymentTransaction: query)
    }
}
