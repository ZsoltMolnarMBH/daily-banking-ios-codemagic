//
//  TransferFeeProcess.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 26..
//

import Resolver

extension MoneyProcess {
    var localizedTransactionFee: String? {
        switch self {
        case .loading:
            return nil
        case .success(let money):
            return money.localizedTransactionFee
        case .failure:
            return Strings.Localizable.newTransferTransactionFeeNoData
        }
    }
}

extension Money {
    var localizedTransactionFee: String {
        Strings.Localizable.newTransferTransactionFee(self.localizedString)
    }
}
