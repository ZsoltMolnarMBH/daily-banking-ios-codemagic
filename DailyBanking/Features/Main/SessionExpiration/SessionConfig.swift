//
//  SessionConfig.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 10..
//

import Foundation

protocol SessionConfig {
    var backgroundExpirationTime: Double { get }
    var foregroundInactivityWarningTime: Double { get }
    var foregroundInactivityExpirationTime: Double { get }
}
