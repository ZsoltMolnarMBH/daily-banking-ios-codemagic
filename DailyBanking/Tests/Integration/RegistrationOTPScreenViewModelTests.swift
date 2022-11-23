//
//  RegistrationOTPScreenViewModelTests.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 11. 16..
//

import XCTest
import Combine
import Resolver
import DesignKit
import SwiftyMocky

@testable import DailyBanking

class RegistrationOTPScreenViewModelTests: BaseTestCase {
    var action: AuthenticationActionMock!
    var draft: ReadOnly<RegistrationDraft>!
    var disposeBag: Set<AnyCancellable>!
    var sut: RegistrationOTPScreenViewModel!

    override func setUp() {
        let container = Resolver.registration

        draft = .init(value: .initialState,
                      publisher: Just(RegistrationDraft.initialState).eraseToAnyPublisher())
        container.register { self.draft }
        action = .init()
        container.register { self.action as AuthenticationAction }
        disposeBag = Set<AnyCancellable>()

        let success: AnyPublisher<Never, Error> = Just<Void>(()).setFailureType(to: Error.self).ignoreOutput().eraseToAnyPublisher()
        Given(action, .register(phoneNumber: .any, email: .any, passwordHash: .any, willReturn: success))

        sut = RegistrationOTPScreenViewModel()
    }

    override func tearDown() {
        sut = nil
        draft = nil
        action = nil
        disposeBag = nil
    }

    func testEnterSMSOTP() {
        // Given
        let success: AnyPublisher<Never, Error> = Just<Void>(()).setFailureType(to: Error.self).ignoreOutput().eraseToAnyPublisher()
        Given(action, .verifyOTP(otp: .any, willReturn: success))
        let expectation = XCTestExpectation()

        // When
        sut.smsOTP = "123456"
        var results: [DesignTextField.ValidationState] = []
        sut.$smsFieldState.sink {
            results.append($0)
            if $0 == .validated { expectation.fulfill() }
        }.store(in: &disposeBag)
        wait(for: [expectation], timeout: 0.5)

        // Then
        Verify(action, 1, .verifyOTP(otp: .any))
        XCTAssertEqual(results, [.loading, .validated])
    }

    func testEnterSMSOTP_DoubleQuickEntry() {
        // Given
        let success: AnyPublisher<Never, Error> = Just<Void>(()).setFailureType(to: Error.self).ignoreOutput().eraseToAnyPublisher()
        Given(action, .verifyOTP(otp: .any, willReturn: success))
        let expectation = XCTestExpectation()

        // When
        sut.smsOTP = "123456"
        sut.smsOTP = "123457"
        var results: [DesignTextField.ValidationState] = []
        sut.$smsFieldState.sink {
            results.append($0)
            if $0 == .validated { expectation.fulfill() }
        }.store(in: &disposeBag)
        wait(for: [expectation], timeout: 0.5)

        // Then
        Verify(action, 1, .verifyOTP(otp: .value("123457")))
        XCTAssertEqual(results, [.loading, .validated])
    }
}

private extension RegistrationDraft {
    static var initialState: RegistrationDraft {
        .init(phoneNumber: "+36301234567",
              email: "a@s.d",
              passwordHash: "onfcoqinviepwsa",
              smsOtpInfo: nil,
              registeredUser: nil,
              token: nil)
    }
}
