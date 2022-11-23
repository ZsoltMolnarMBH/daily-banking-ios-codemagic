//
//  StringValidatorTests.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 14..
//

import XCTest
@testable import DailyBanking

class StringValidatorTests: BaseTestCase {

    func testIDNumberValidator() {
        XCTAssertTrue("123456AA".matches(pattern: .idNumber))
        XCTAssertTrue("RH-I 123456".matches(pattern: .idNumber))
        XCTAssertTrue("RH-II 123456".matches(pattern: .idNumber))
        XCTAssertTrue("RH-I123456".matches(pattern: .idNumber))
        XCTAssertTrue("RH-II123456".matches(pattern: .idNumber))
        XCTAssertTrue("RH-I. 123456".matches(pattern: .idNumber))
        XCTAssertTrue("RH-II. 123456".matches(pattern: .idNumber))
        XCTAssertTrue("RH-I.123456".matches(pattern: .idNumber))
        XCTAssertTrue("RH-II.123456".matches(pattern: .idNumber))
        XCTAssertFalse("AA123456".matches(pattern: .idNumber))
        XCTAssertFalse("12AA3456".matches(pattern: .idNumber))
        XCTAssertFalse("A123456A".matches(pattern: .idNumber))
        XCTAssertFalse("12345AA".matches(pattern: .idNumber))
        XCTAssertFalse("123456A".matches(pattern: .idNumber))
        XCTAssertFalse("".matches(pattern: .idNumber))
    }

    func testAddressNumberValidator() {
        XCTAssertTrue("123456AA".matches(pattern: .addressCard))
        XCTAssertFalse("AA123456".matches(pattern: .addressCard))
        XCTAssertFalse("12AA3456".matches(pattern: .addressCard))
        XCTAssertFalse("A123456A".matches(pattern: .addressCard))
    }

    func testEmailValidator() {
        XCTAssertTrue("something@gmail.com".matches(pattern: .email))
        XCTAssertFalse("something@gmail@com".matches(pattern: .email))
        XCTAssertFalse("something.gmail.com".matches(pattern: .email))
        XCTAssertFalse("somethinggmailcom".matches(pattern: .email))
    }
}
