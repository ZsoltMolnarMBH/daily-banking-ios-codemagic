//
//  KycConfig.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 10..
//

import Foundation

protocol KycConfig {
    var safeDocumentPreviews: Bool { get }
    var autoCloseRoom: Bool { get }
    var useFlashOnHologramCheck: Bool { get }
    var selfieCropSize: Double { get }
}
