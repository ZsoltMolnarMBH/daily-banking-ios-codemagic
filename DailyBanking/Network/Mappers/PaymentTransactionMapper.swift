//
//  PaymentTransactionMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 01..
//

import BankAPI
import Foundation
import Resolver

class PaymentTransactionMapper: Mapper<PaymentTransactionFragment, PaymentTransaction> {
    @Injected private var rejectionMapper: Mapper<RejectionReason, TransferRejection>
    @Injected private var moneyMapper: Mapper<MoneyFragment, Money>

    override func map(_ item: PaymentTransactionFragment) throws -> PaymentTransaction {
        guard let createdAt = BankAPI.dateFormatters.date(from: item.createdAt) else {
            throw makeError(item: item, reason: "invalid date format at: .createdAt")
        }

        var settlementDate: Date?
        if let settlementDateString = item.settlementDate,
           let date = BankAPI.dateFormatters.date(from: settlementDateString) {
            settlementDate = date
        }

        let direction: PaymentTransaction.Direction = item.direction == .incoming ? .receive : .send
        let name = direction == .receive ? item.debtor.fragments.participantFragment.name : item.creditor.fragments.participantFragment.name

        let creditorAccount = item.creditor.fragments.participantFragment.account.identification
        let debtorAccount = item.debtor.fragments.participantFragment.account.identification
        let accountNumber = direction == .receive ? debtorAccount : creditorAccount

        let state: PaymentTransaction.State
        switch item.status {
        case .completed:
            state = .completed
        case .initiated, .pending:
            state = .pending
        case .rejected:
            state = .rejected
        case .__unknown(let status):
            throw makeError(item: item, reason: "Unknown transaction status: \(status)")
        }

        var mappedRejection: TransferRejection?
        if let rejection = item.rejectionReason {
            mappedRejection = try? rejectionMapper.map(rejection)
        }

        let amount = item.money.fragments.moneyFragment
        let mappedAmount = try moneyMapper.map(amount)
        let fee = item.fee?.fragments.moneyFragment
        var mappedFee: Money?
        if let fee = fee {
            mappedFee = try moneyMapper.map(fee)
        }

        return PaymentTransaction(
            id: item.id,
            name: name,
            createdAt: createdAt,
            settlementDate: settlementDate,
            amount: mappedAmount,
            fee: mappedFee,
            state: state,
            direction: direction,
            accountNumber: accountNumber,
            reference: item.paymentReference,
            rejectionReason: mappedRejection
        )
    }
}
