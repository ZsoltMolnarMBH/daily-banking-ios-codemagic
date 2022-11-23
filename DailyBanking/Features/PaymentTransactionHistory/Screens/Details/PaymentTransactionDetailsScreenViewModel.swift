//
//  PaymentTransactionDetailsScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 03..
//

import Combine
import Foundation
import UIKit

class PaymentTransactionDetailsScreenViewModel: PaymentTransactionDetailsScreenViewModelProtocol {
    @Published var icon: ImageName = .giroNeutral
    @Published var titleAmount: MoneyViewModel = .zeroHUF
    @Published var date: String = ""
    @Published var isIncoming: Bool = true
    @Published var isRejected: Bool = false
    @Published var name: String = ""
    @Published var accountNumber: String = ""
    @Published var notice: String?
    @Published var amount: String = ""
    @Published var fee: String?
    @Published var statusText: String = ""
    @Published var statusDetail: String?
    @Published var transactionId: String = ""
    private var toastSubject = PassthroughSubject<String, Never>()
    var toast: AnyPublisher<String, Never> {
        toastSubject.eraseToAnyPublisher()
    }

    var transaction: PaymentTransaction! {
        didSet {
            setup(with: transaction)
        }
    }

    private var prefix: String {
        if transaction.state == .rejected {
            return ""
        }
        if transaction.direction == .receive {
            return "+"
        } else {
            return "-"
        }
    }

    private func setup(with transaction: PaymentTransaction) {
        let rawAmount: MoneyViewModel = .make(using: transaction.amount)
        titleAmount = .init(amount: prefix + rawAmount.amount, currency: rawAmount.currency)
        if let feeValue = transaction.fee?.localizedString {
             fee = Strings.Localizable.transactionDetailsTransactionFee(feeValue)
        }
        amount = transaction.amount.localizedString
        date = DateFormatter.userFacingWithTime.string(from: transaction.createdAt)
        isIncoming = transaction.direction == .receive
        isRejected = transaction.state == .rejected
        name = transaction.name
        accountNumber = transaction.accountNumber.formatted(pattern: .accountNumber)
        notice = transaction.reference

        switch transaction.state {
        case .rejected:
            statusText = Strings.Localizable.transactionStatusRejected
            icon = .alertNeutral
            statusDetail = transaction.rejectionReason?.localizedString
        case .completed:
            statusText = Strings.Localizable.transactionStatusBooked
            let dateFormatter = DateFormatter.userFacing
            if let settlementDate = transaction.settlementDate {
                statusDetail = dateFormatter.string(from: settlementDate)
            } else {
                statusDetail = nil
            }
            icon = .giroNeutral
        case .pending:
            statusText = Strings.Localizable.transactionStatusUnderBooking
            statusDetail = Strings.Localizable.transactionStatusUnderBookingDescription
            icon = .giroNeutral
        }
        transactionId = transaction.id
    }

    func handle(_ event: PaymentTransactionDetailsScreenInput) {
        switch event {
        case .copyAccountNumber:
            UIPasteboard.general.string = accountNumber
            toastSubject.send(Strings.Localizable.commonAccountNumberCopiedToClipboard)
        }
    }
}
