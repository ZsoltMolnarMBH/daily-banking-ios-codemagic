//
//  NewTransferConfig.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 09..
//

import Foundation

protocol NewTransferConfig {
    var pollCount: Int { get }
    var pollingInterval: Double { get }
    var feeFetchDebounceTime: Double { get }
    var isInlineValidationEnabled: Bool { get }
}
