//
//  PinCreationTests.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 08..
//

import Foundation
import Resolver
import SwiftyMocky
import Combine
import XCTest

@testable import DailyBanking

class PinCreationTests: BaseTestCase {
    var sut: PinCreationScreenViewModel!

    override func setUp() {
        container = appCoordiantor
            .container
            .makeChild()
            .assembled(using: RegistrationAssembly())

        container.useContext {
            sut = PinCreationScreenViewModel()
        }
    }

    override func tearDown() {
        sut = nil
    }

//    func testPinEntry2() {
//        // Given
//        let givenPinCode: PinCode = [1, 2]
//
//        // When
//        sut.pin = givenPinCode
//
//        // Then
//        XCTAssertEqual(sut.pinState, .editing)
//    }
//
//    func testPinEntry5() {
//        // Given
//        let givenPinCode: PinCode = [1, 2, 3, 4, 5]
//
//        // When
//        sut.pin = givenPinCode
//
//        // Then
//        XCTAssertEqual(sut.pinState, .editing)
//    }
//
//    func testPinEntry_FirstComplete_Failure_MatchingCharacters() {
//        // Given
//        let givenPinCode: PinCode = [1, 1, 1, 1, 1, 1]
//
//        // When
//        sut.pin = givenPinCode
//
//        // Then
//        XCTAssertEqual(sut.pinState, .error)
//    }
//
//    func testPinEntry_FirstComplete_Failure_SequencialCharacters() {
//        // Given
//        let givenPinCode: PinCode = [1, 2, 3, 4, 5, 6]
//
//        // When
//        sut.pin = givenPinCode
//
//        // Then
//        XCTAssertEqual(sut.pinState, .error)
//    }
//
//    func testPinEntry_FirstComplete_Failure_SequencialCharactersReversed() {
//        // Given
//        let givenPinCode: PinCode = [6, 5, 4, 3, 2, 1]
//
//        // When
//        sut.pin = givenPinCode
//
//        // Then
//        XCTAssertEqual(sut.pinState, .error)
//    }
//
//    func testPinEntry_FirstComplete_Success() {
//        // Given
//        let givenPinCode: PinCode = [1, 2, 3, 3, 3, 3]
//
//        // When
//        sut.pin = givenPinCode
//
//        // Then
//        XCTAssertEqual(sut.pinState, .success)
//    }
//
//    func testPinEntry_SecondBeingEdited() {
//        // Given
//        let firstPin: PinCode = [1, 2, 3, 3, 3, 3]
//        let secondPin: PinCode = [1, 2, 3]
//
//        // When
//        sut.firstPin = firstPin
//        sut.pin = secondPin
//
//        // Then
//        XCTAssertEqual(sut.pinState, .editing)
//    }
//
//    func testPinEntry_SecondComplete_Failure_MismatchingPins() {
//        // Given
//        let firstPin: PinCode = [1, 2, 3, 3, 3, 3]
//        let secondPin: PinCode = [1, 2, 3, 4, 4, 4]
//
//        // When
//        sut.firstPin = firstPin
//        sut.pin = secondPin
//
//        // Then
//        XCTAssertEqual(sut.pinState, .error)
//    }
//
//    func testPinEntry_SecondComplete_Success() {
//        // Given
//        let firstPin: PinCode = [1, 2, 3, 3, 3, 3]
//        let secondPin: PinCode = [1, 2, 3, 3, 3, 3]
//
//        // When
//        sut.firstPin = firstPin
//        sut.pin = secondPin
//
//        // Then
//        XCTAssertEqual(sut.pinState, .success)
//    }
}
