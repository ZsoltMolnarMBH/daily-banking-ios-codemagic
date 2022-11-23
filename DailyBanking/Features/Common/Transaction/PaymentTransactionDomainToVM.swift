//
//  PaymentTransactionDomainToVM.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 01..
//

import Foundation

struct PaymentTransactionViewModelMapper {
    let dateFormatter: (Date) -> String
    func map(_ transaction: PaymentTransaction, action: @escaping () -> Void) -> PaymentTransactionItemVM {
        let status: PaymentTransactionItemVM.Status
        let subtitle = dateFormatter(transaction.createdAt)
        var detail: PaymentTransactionItemVM.Detail?
        if transaction.state == .rejected {
            status = .rejected
            if let rejectReason = transaction.rejectionReason {
                detail = .text(rejectReason.localizedString)
            }
        } else {
            if let fee = transaction.fee?.localizedString {
                detail = .fee(fee)
            }
            switch transaction.direction {
            case .receive:
                status = .incoming
            case .send:
                status = .outgoing
            }
        }
        return PaymentTransactionItemVM(
            id: transaction.id,
            imageName: transaction.state == .rejected ? .alertNeutral : .giroNeutral,
            title: transaction.name,
            subtitle: subtitle,
            amount: transaction.amount.localizedString,
            detail: detail,
            status: status,
            action: action
        )
    }
}
