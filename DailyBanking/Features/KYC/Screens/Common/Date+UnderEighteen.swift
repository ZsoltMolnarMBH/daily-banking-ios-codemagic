//
//  Date+UnderEighteen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 11..
//

import Foundation

extension Date {
    var isUnderEighteen: Bool {
        guard let eighteenYearsBefore = Calendar.current.date(byAdding: .year, value: -18, to: Date()) else { return false }
        return self > eighteenYearsBefore
    }
}
