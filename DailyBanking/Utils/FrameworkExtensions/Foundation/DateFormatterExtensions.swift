//
//  DateFormatterExtensions.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 18..
//

import Foundation

extension DateFormatter {
    /// Ma
    static let relativeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    // Ma 14:22
    static let relativeFormatterWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    /// augusztus 1.
    static let monthAndDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d."
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    /// augusztus 1. 14:22
    static let monthAndDayWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d. HH:mm"
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    /// 2021. augusztus
    static let yearAndMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MMMM"
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    ///  2021-08-12
    static let simple: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    ///  2021. augusztus 12.
    static let userFacing: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MMMM dd."
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    ///  2021. augusztus 12. 14:22
    static let userFacingWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MMMM dd. HH:mm"
        formatter.locale = Locale(identifier: "hu")
        return formatter
    }()

    func date(optional dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        return date(from: dateString)
    }

    func string(optional date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return string(from: date)
    }
}

extension Array where Element == DateFormatter {
    func date(from string: String) -> Date? {
        for formatter in self {
            if let date = formatter.date(from: string) {
                return date
            }
        }
        return nil
    }
}
