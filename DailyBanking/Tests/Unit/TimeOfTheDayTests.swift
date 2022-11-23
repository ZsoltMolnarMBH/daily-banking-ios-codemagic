//
//  TimeOfTheDay.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 21..
//

import XCTest
@testable import DailyBanking

class TimeOfTheDayTests: BaseTestCase {
    func testTimeOfDay() {
        let calendar = Calendar.current

        let date = calendar.date(bySettingHour: 4, minute: 22, second: 17, of: Date())
        let morning = date!.timeOfDay

        let date2 = calendar.date(bySettingHour: 9, minute: 59, second: 59, of: Date())
        let morning2 = date2!.timeOfDay

        let date3 = calendar.date(bySettingHour: 3, minute: 59, second: 59, of: Date())
        let night = date3!.timeOfDay

        let date4 = calendar.date(bySettingHour: 18, minute: 00, second: 0, of: Date())
        let night2 = date4!.timeOfDay

        let date5 = calendar.date(bySettingHour: 10, minute: 00, second: 00, of: Date())
        let afternoon = date5!.timeOfDay

        let date6 = calendar.date(bySettingHour: 17, minute: 59, second: 59, of: Date())
        let afternoon2 = date6!.timeOfDay

        XCTAssertEqual(morning, .morning)
        XCTAssertEqual(morning2, .morning)
        XCTAssertEqual(night, .night)
        XCTAssertEqual(night2, .night)
        XCTAssertEqual(afternoon, .afternoon)
        XCTAssertEqual(afternoon2, .afternoon)
    }
}
