//
//  String+Analytics.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 20..
//

import Foundation

extension String {
    var asAnalyticsTitle: String {
        self.folding(options: .diacriticInsensitive, locale: .current).lowercased().replacingOccurrences(of: " ", with: "_")
    }
}
