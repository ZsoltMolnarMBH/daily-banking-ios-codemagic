//
//  Date+Extensions.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 21..
//

import Foundation

extension Date {
    enum TimeOfDay {
        case morning
        case afternoon
        case night
    }

    var timeOfDay: TimeOfDay {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 4...9:
            return .morning
        case 10...17:
            return .afternoon
        default:
            return .night
        }
    }
}

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    var isInThisYear: Bool { isInSameYear(as: Date()) }
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
}
