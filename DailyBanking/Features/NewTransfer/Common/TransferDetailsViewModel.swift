//
//  TransferDetailsViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 28..
//

import Foundation

struct TransferDetailsViewModel {
    var beneficiaryName: String
    var accountNumber: String
    var money: String
    var fee: String?
    var notice: String?
    var transferDate: String
    var transferType: String
}
