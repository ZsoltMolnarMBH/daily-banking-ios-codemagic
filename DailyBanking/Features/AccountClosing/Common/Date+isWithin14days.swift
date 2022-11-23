//
//  Date+isWithin14days.swift
//  DailyBanking
//
//  Created by ALi on 2022. 06. 10..
//

import Foundation

extension Date {
    var isWithin14days: Bool {
        guard let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date()) else { return true }
        return self > twoWeeksAgo
    }
}
