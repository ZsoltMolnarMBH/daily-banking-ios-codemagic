//
//  AccountOpeningStartPageScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 30..
//

import Foundation

protocol AccountOpeningStartPageScreenListener: AnyObject {
    func accountPackageDetailsScreenRequested()
}

class AccountOpeningStartPageScreenViewModel: AccountOpeningStartPageScreenViewModelProtocol {

    weak var screenListener: AccountOpeningStartPageScreenListener?

    func handle(_ event: AccountOpeningStartPageScreenInput) {
        switch event {
        case .nextButtonPressed:
            screenListener?.accountPackageDetailsScreenRequested()
        }
    }
}
