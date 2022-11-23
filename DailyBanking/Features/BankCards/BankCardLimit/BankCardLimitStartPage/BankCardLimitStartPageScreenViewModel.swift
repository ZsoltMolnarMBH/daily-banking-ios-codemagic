//
//  BankCardLimitStartPageScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 08..
//

import Foundation

protocol BankCardLimitStartPageScreenListener: AnyObject {
    func creditCardLimitScreenRequested()
    func cashWithdrawlLimitScreenRequested()
}

class BankCardLimitStartPageScreenViewModel: BankCardLimitStartPageScreenViewModelProtocol {
    weak var screenListener: BankCardLimitStartPageScreenListener?

    func handle(event: BankCardLimitStartPageScreenInput) {
        switch event {
        case .creditCardLimit:
            screenListener?.creditCardLimitScreenRequested()
        case .cashWithdrawlLimit:
            screenListener?.cashWithdrawlLimitScreenRequested()
        }
    }
}
