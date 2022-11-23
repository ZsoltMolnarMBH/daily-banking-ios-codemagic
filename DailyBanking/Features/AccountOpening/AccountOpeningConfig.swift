//
//  AccountOpeningConfig.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 10..
//

import Foundation

protocol AccountOpeningConfig {
    var isKycEnabled: Bool { get }
    var skipEmailValidation: Bool { get }
}
