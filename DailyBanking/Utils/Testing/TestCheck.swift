//
//  TestCheck.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 11. 19..
//

import Foundation

// swiftlint:disable all
func isRunningTests() -> Bool {
#if DEBUG
    if (NSClassFromString("XCTest") == nil) {
        return false
    }
    return true
#else
    return false
#endif
}
// swiftlint:enable all
