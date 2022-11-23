//
//  NewTransferResult.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 28..
//

import Foundation

struct NewTransferSuccess {
    let transaction: PaymentTransaction?
}

enum NewTransferError: Error, Equatable {
    case rejected(TransferRejection)
    case unknown
}

typealias NewTransferResult = Result<NewTransferSuccess, NewTransferError>
