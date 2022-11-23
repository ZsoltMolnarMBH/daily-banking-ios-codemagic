//
//  UserFacingRelativeDateFormatter.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 02..
//

import Foundation

class UserFacingRelativeDateFormatter {
    static func string(from date: Date, includeTime: Bool) -> String {
        if includeTime {
            if date.isInToday || date.isInYesterday {
                return DateFormatter.relativeFormatterWithTime.string(from: date).capitalized
            } else if date.isInThisYear {
                return DateFormatter.monthAndDayWithTime.string(from: date).capitalized
            } else {
                return DateFormatter.userFacingWithTime.string(from: date).capitalized
            }
        } else {
            if date.isInToday || date.isInYesterday {
                return DateFormatter.relativeFormatter.string(from: date).capitalized
            } else if date.isInThisYear {
                return DateFormatter.monthAndDay.string(from: date).capitalized
            } else {
                return DateFormatter.userFacing.string(from: date).capitalized
            }
        }
    }
}
