//
//  RegistrationActionTests.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 07..
//

import Foundation
import Resolver
import SwiftyMocky
import BankAPI
import Combine
import Apollo
import XCTest

@testable import DailyBanking
import CryptoKit

class RegistrationActionTests: BaseTestCase {
    var apiMock: APIProtocolMock!
    var otpGeneratorMock: OtpGeneratorMock!
    var disposeBag: Set<AnyCancellable>!
    var sut: RegisterActionImpl!

    override func setUp() {
        container = appCoordiantor
            .container
            .makeChild()
            .assembled(using: RegistrationAssembly())

        apiMock = APIProtocolMock()
        otpGeneratorMock = OtpGeneratorMock()
        container.register { self.apiMock as APIProtocol }
        container.register { self.otpGeneratorMock as OtpGenerator }
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = RegisterActionImpl()
        }
    }

    override func tearDown() {
        apiMock = nil
        disposeBag = nil
        sut = nil
    }

    func testVerifyPhoneNumber_Success() throws {
        // Given
        let givenPhoneNumber = "+36301234567"

        let response = Just(VerifyPhoneQuery.Data(verifyPhone: .init(status: .ok)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<VerifyPhoneQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: response)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verify(phoneNumber: givenPhoneNumber)
            .sink { event in
                switch event {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    Failure("Unexpected failure: \(error)")
                }
            }
            .store(in: &disposeBag)


        // Then
        wait(for: [expectation], timeout: 4)
    }

    func testVerifyPhoneNumber_Failure_AlreadyRegistered() throws {
        // Given
        let givenPhoneNumber = "+36301234567"

        let response = Just(VerifyPhoneQuery.Data(verifyPhone: .init(status: .error)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<VerifyPhoneQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: response)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        var errors: [Error] = []
        sut.verify(phoneNumber: givenPhoneNumber)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Unexpected success")
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        errors.append(actionError)
                        expectation.fulfill()
                    default:
                        Failure("Unexpected error type!")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        guard let errors = errors as? [VerifyPhoneError] else {
            Failure("Unexpected error type")
        }
        XCTAssertEqual(errors, [.phoneNumberAlreadyRegistered])
    }


    func testRegister_Success() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenEmail = "a@s.d"
        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let responseExpireInterval: Double = 10
        let responseNextRequestInterval: Double = 5
        let responseTemporaryToken = "asdasdasd"
        let response = Just(RegisterMutation.Data(register: .init(
                temporaryToken: responseTemporaryToken,
                otpInfo: .init(expireInterval: responseExpireInterval, nextRequestInterval: responseNextRequestInterval)
            )))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<RegisterMutation>.any,
            willReturn: response)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.register(phoneNumber: givenPhoneNumber,
                     email: givenEmail,
                     passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    Failure("Unexpected failure: \(error)")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<RegisterMutation>.any))
        XCTAssertEqual(tokenStore.state.value, .init(
            accessToken: responseTemporaryToken,
            refreshToken: ""))
    }

    func testRegister_failed_general() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenEmail = "a@s.d"
        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<RegisterMutation.Data, Error> = Fail<RegisterMutation.Data, Error>(
            outputType: RegisterMutation.Data.self,
            failure: TestError.simple
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<RegisterMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.register(phoneNumber: givenPhoneNumber,
                     email: givenEmail,
                     passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed")
                case .failure:
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<RegisterMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }
    
    func testRegister_failed_temporary_blocked() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenEmail = "a@s.d"
        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<RegisterMutation.Data, Error> = Fail<RegisterMutation.Data, Error>(
            outputType: RegisterMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.temporaryBlocked])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<RegisterMutation>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.register(phoneNumber: givenPhoneNumber,
                     email: givenEmail,
                     passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed")
                case .failure(let error):
                    if case .action(let actionError) = error, case .temporaryBlocked(blockedTime: let blockedTime) = actionError {
                        XCTAssertEqual(blockedTime, 15)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<RegisterMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }
    
    func testRegister_failed_not_allowed() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenEmail = "a@s.d"
        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<RegisterMutation.Data, Error> = Fail<RegisterMutation.Data, Error>(
            outputType: RegisterMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.notAllowed])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<RegisterMutation>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.register(phoneNumber: givenPhoneNumber,
                     email: givenEmail,
                     passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed")
                case .failure(let error):
                    if case .action(let actionError) = error, case .notAllowed = actionError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<RegisterMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testDeviceActivation_Success() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let responseExpireInterval: Double = 10
        let responseNextRequestInterval: Double = 5
        let responseTemporaryToken = "asdasdasd"

        let response = Just(DeviceActivationMutation.Data(deviceActivation: .init(
                temporaryToken: responseTemporaryToken,
                otpInfo: .init(expireInterval: responseExpireInterval, nextRequestInterval: responseNextRequestInterval
            ))))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<DeviceActivationMutation>.any,
            willReturn: response)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.activateDevice(phoneNumber: givenPhoneNumber,
                           passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    Failure("Unexpected failure: \(error)")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<DeviceActivationMutation>.any))
        XCTAssertEqual(tokenStore.state.value, .init(
            accessToken: responseTemporaryToken,
            refreshToken: ""))
    }

    func testDeviceActivation_failed_general() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<DeviceActivationMutation.Data, Error> = Fail<DeviceActivationMutation.Data, Error>(
            outputType: DeviceActivationMutation.Data.self,
            failure: TestError.simple
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<DeviceActivationMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.activateDevice(phoneNumber: givenPhoneNumber,
                           passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed")
                case .failure(let error):
                    if case .action = error {
                        Failure("Invalid error type")
                    }
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<DeviceActivationMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testDeviceActivation_failed_unauthorized() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<DeviceActivationMutation.Data, Error> = Fail<DeviceActivationMutation.Data, Error>(
            outputType: DeviceActivationMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.unauthorized])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<DeviceActivationMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.activateDevice(phoneNumber: givenPhoneNumber,
                           passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed")
                case .failure(let error):
                    if case .action(let actionError) = error, case .unauthorized(remainingAttempts: let remaining) = actionError {
                        XCTAssertEqual(remaining, 4)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<DeviceActivationMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testDeviceActivation_failed_temporary_blocked() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<DeviceActivationMutation.Data, Error> = Fail<DeviceActivationMutation.Data, Error>(
            outputType: DeviceActivationMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.temporaryBlocked])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<DeviceActivationMutation>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.activateDevice(phoneNumber: givenPhoneNumber,
                           passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed")
                case .failure(let error):
                    if case .action(let actionError) = error, case .temporaryBlocked(let blockedTime) = actionError {
                        XCTAssertEqual(blockedTime, 15)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<DeviceActivationMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testDeviceActivation_failed_blocked() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenPasswordHash = "asdasd123"
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<DeviceActivationMutation.Data, Error> = Fail<DeviceActivationMutation.Data, Error>(
            outputType: DeviceActivationMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.blocked])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<DeviceActivationMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.activateDevice(phoneNumber: givenPhoneNumber,
                           passwordHash: givenPasswordHash)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed")
                case .failure(let error):
                    if case .action(let actionError) = error, case .blocked = actionError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<DeviceActivationMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testVerifyOTP_Success() {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenOTP = "123456"

        let responseAccessToken = "asdasd1"
        let responseRefershToken = "asdasd2"
        let response = Just(VerifyOtpMutation.Data(verifyOtp: .init(
            accessToken: responseAccessToken,
            refreshToken: responseRefershToken)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<VerifyOtpMutation>.any,
            willReturn: response)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verifyOTP(otp: givenOTP)
            .sink { event in
                switch event {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    Failure("Unexpected failure: \(error)")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<VerifyOtpMutation>.any))
        XCTAssertEqual(tokenStore.state.value,
                       Token(accessToken: responseAccessToken, refreshToken: responseRefershToken))
    }

    func testVerifyOTP_failed_generic() {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenOTP = "123456"
        let failure: AnyPublisher<VerifyOtpMutation.Data, Error> = Fail<VerifyOtpMutation.Data, Error>(
            outputType: VerifyOtpMutation.Data.self,
            failure: TestError.simple
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<VerifyOtpMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verifyOTP(otp: givenOTP)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response shoould be failed!")
                case .failure(let error):
                    if case .action = error {
                        Failure("Unexpected failure: \(error)")
                    } else {
                        expectation.fulfill()
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<VerifyOtpMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testVerifyOTP_failed_too_many_tries() {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenOTP = "123456"
        let failure: AnyPublisher<VerifyOtpMutation.Data, Error> = Fail<VerifyOtpMutation.Data, Error>(
            outputType: VerifyOtpMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.tooManyTry])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<VerifyOtpMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verifyOTP(otp: givenOTP)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response shoould be failed!")
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        switch actionError {
                        case .tooManyTry:
                            expectation.fulfill()
                        default:
                            Failure("Unexpected failure: \(error)")
                        }
                    default:
                        Failure("Unexpected failure: \(error)")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<VerifyOtpMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testVerifyOTP_failed_expired() {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenOTP = "123456"
        let failure: AnyPublisher<VerifyOtpMutation.Data, Error> = Fail<VerifyOtpMutation.Data, Error>(
            outputType: VerifyOtpMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.expired])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<VerifyOtpMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verifyOTP(otp: givenOTP)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response shoould be failed!")
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        switch actionError {
                        case .expired:
                            expectation.fulfill()
                        default:
                            Failure("Unexpected failure: \(error)")
                        }
                    default:
                        Failure("Unexpected failure: \(error)")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<VerifyOtpMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testVerifyOTP_failed_wrong_otp_parse_remaining_tries() {
        // Given
        let tokenStore: any TokenStore = container.resolve()

        let givenOTP = "123456"
        let failure: AnyPublisher<VerifyOtpMutation.Data, Error> = Fail<VerifyOtpMutation.Data, Error>(
            outputType: VerifyOtpMutation.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.wrongOtp])
        ).eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<VerifyOtpMutation>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verifyOTP(otp: givenOTP)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response shoould be failed!")
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        switch actionError {
                        case .wrongOtp(remainingAttempts: let attempts):
                            XCTAssertEqual(attempts, 2)
                            expectation.fulfill()
                        default:
                            Failure("Unexpected failure: \(error)")
                        }
                    default:
                        Failure("Unexpected failure: \(error)")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<VerifyOtpMutation>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
    }

    func testResendOtp_failed_too_soon() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()
        let draftStore: any RegistrationDraftStore = container.resolve()
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<ResendOtpQuery.Data, Error> = Fail<ResendOtpQuery.Data, Error>(
            outputType: ResendOtpQuery.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.tooSoonOtp])
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ResendOtpQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.resendOtp(phoneNumber: givenPhoneNumber)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed!")
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        switch actionError {
                        case .tooSoonRequest:
                            expectation.fulfill()
                        default:
                            Failure("Invalid error type \(actionError)")
                        }
                    default:
                        Failure("Invalid error type \(error)")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<ResendOtpQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
        XCTAssertEqual(draftStore.state.value.smsOtpInfo?.remainingResendAttempts, nil)
    }

    func testResendOtp_failed_too_many() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()
        let draftStore: any RegistrationDraftStore = container.resolve()
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<ResendOtpQuery.Data, Error> = Fail<ResendOtpQuery.Data, Error>(
            outputType: ResendOtpQuery.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.tooManyOtp])
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ResendOtpQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.resendOtp(phoneNumber: givenPhoneNumber)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed!")
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        switch actionError {
                        case .tooManyRequests:
                            expectation.fulfill()
                        default:
                            Failure("Invalid error type \(actionError)")
                        }
                    default:
                        Failure("Invalid error type \(error)")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<ResendOtpQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
        XCTAssertEqual(draftStore.state.value.smsOtpInfo?.remainingResendAttempts, nil)
    }

    func testResendOtp_failed_generic() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()
        let draftStore: any RegistrationDraftStore = container.resolve()
        let givenPhoneNumber = "+36301234567"

        let failure: AnyPublisher<ResendOtpQuery.Data, Error> = Fail<ResendOtpQuery.Data, Error>(
            outputType: ResendOtpQuery.Data.self,
            failure: TestError.simple
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ResendOtpQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.resendOtp(phoneNumber: givenPhoneNumber)
            .sink { event in
                switch event {
                case .finished:
                    Failure("Response should be failed!")
                case .failure(let error):
                    switch error {
                    case .action(let actionError):
                        switch actionError {
                        case .tooManyRequests, .tooSoonRequest:
                            Failure("Invalid error type \(error)")
                        }
                    default:
                        expectation.fulfill()
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<ResendOtpQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
        XCTAssertEqual(draftStore.state.value.smsOtpInfo?.remainingResendAttempts, nil)
    }

    func testResendOtp_Success() throws {
        // Given
        let tokenStore: any TokenStore = container.resolve()
        let draftStore: any RegistrationDraftStore = container.resolve()
        let givenPhoneNumber = "+36301234567"

        let responseExpireInterval: Double = 10
        let responseNextRequestInterval: Double = 5

        let response = Just(ResendOtpQuery.Data(getOtp: .init(
                remainingAttempts: 2,
                otpInfo: .init(expireInterval: responseExpireInterval, nextRequestInterval: responseNextRequestInterval
            ))))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ResendOtpQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: response)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.resendOtp(phoneNumber: givenPhoneNumber)
            .sink { event in
                switch event {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    Failure("Unexpected failure: \(error)")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<ResendOtpQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value, nil)
        XCTAssertEqual(draftStore.state.value.smsOtpInfo?.remainingResendAttempts, 2)
    }


//    func testSetupDeviceAuthentication_Success() throws {
//        // Given
//        let draftStore: any RegistrationDraftStore = container.resolve()
//        let givenPinCode = [1, 2, 2, 2, 2, 2]
//
//        let prepareTokenResponse = Just(PrepareTokenV2Mutation.Data(prepareTokenV2: .init(token: "preparedToken", dhServer: "ServerPublicKey")))
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//        Given(apiMock, .publisher(
//            for: Parameter<PrepareTokenV2Mutation>.any,
//            willReturn: prepareTokenResponse)
//        )
//        Given(otpGeneratorMock, .createKeyFile(
//            token: .any,
//            privateKey: .any,
//            publicKeyPem: .any,
//            mpin: .any,
//            deviceId: .any,
//            willReturn: CryptoMock.validKeyFile())
//        )
//        Given(otpGeneratorMock, .createOtp(
//            keyFile: .any,
//            mpin: .any,
//            deviceId: .any,
//            willReturn: "generatedOtp")
//        )
//        let checkTokenResponse = Just(CheckTokenV2Query.Data(checkTokenV2: .init(status: .ok)))
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//        Given(apiMock, .publisher(
//            for: Parameter<CheckTokenV2Query>.any,
//            cachePolicy: .any,
//            willReturn: checkTokenResponse)
//        )
//        let expectation = XCTestExpectation()
//        expectation.expectedFulfillmentCount = 1
//        expectation.assertForOverFulfill = true
//
//        // When
//        sut.setupDeviceAuthentication(pin: givenPinCode)
//            .sink { event in
//                switch event {
//                case .finished:
//                    expectation.fulfill()
//                case .failure(let error):
//                    Failure("Unexpected failure: \(error)")
//                }
//            }
//            .store(in: &disposeBag)
//
//        // Then
//        wait(for: [expectation], timeout: 4)
//        Verify(apiMock, 1, .publisher(for: Parameter<PrepareTokenV2Mutation>.any))
//        Verify(apiMock, 1, .publisher(for: Parameter<CheckTokenV2Query>.any, cachePolicy: .value(.fetchIgnoringCacheCompletely)))
//        XCTAssertNotNil(draftStore.state.value.keyFile)
//    }
    // asd
}

private extension GraphQLError {
    static var tooManyTry: GraphQLError {
        .from(string:
            """
            {
                "message": "Wrong refresh token or user not found",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    ""
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "TOO_MANY_OTP_TRY",
                    "statusCode": 429,
                    "message": "",
                    "errors": [],
                    "data": []
                }
            }
            """
        )
    }

    static var expired: GraphQLError {
        .from(string:
            """
            {
                "message": "Wrong refresh token or user not found",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    ""
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "OTP_EXPIRED",
                    "statusCode": 408,
                    "message": "",
                    "errors": [],
                    "data": []
                }
            }
            """
        )
    }

    static var wrongOtp: GraphQLError {
        .from(string:
            """
            {
                "message": "Wrong refresh token or user not found",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    ""
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "WRONG_OTP",
                    "statusCode": 400,
                    "message": "",
                    "errors": [],
                    "data": {
                        "remainingAttempts": 2
                    }
                }
            }
            """
        )
    }

    static var tooSoonOtp: GraphQLError {
        .from(string:
            """
            {
                "message": "Wrong refresh token or user not found",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    ""
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "TOO_SOON_OTP_REQUEST",
                    "statusCode": 429,
                    "message": "",
                    "errors": [],
                    "data": []
                }
            }
            """
        )
    }

    static var tooManyOtp: GraphQLError {
        .from(string:
            """
            {
                "message": "Wrong refresh token or user not found",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    ""
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "TOO_MANY_OTP_REQUEST",
                    "statusCode": 429,
                    "message": "",
                    "errors": [],
                    "data": []
                }
            }
            """
        )
    }

    static var unauthorized: GraphQLError {
        .from(string:
            """
            {
                "message": "Unauthorized",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    "login"
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "UNAUTHORIZED",
                    "statusCode": 401,
                    "message": "Unauthorized",
                    "errors": [],
                    "data": {"remainingAttempts":4}
                }
            }
            """
        )
    }

    static var temporaryBlocked: GraphQLError {
        .from(string:
            """
            {
                "message": "The request frequency is too high.",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    "login"
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "TEMPORARY_BLOCKED",
                    "statusCode": 423,
                    "message": "The request frequency is too high.",
                    "errors": [],
                    "data": {"blockedTime":15}
                }
            }
            """
        )
    }

    static var blocked: GraphQLError {
        .from(string:
            """
            {
                "message": "The request frequency is too high.",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    "login"
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "BLOCKED",
                    "statusCode": 423,
                    "message": "The request frequency is too high.",
                    "errors": [],
                    "data": []
                }
            }
            """
        )
    }

    static var notAllowed: GraphQLError {
        .from(string:
            """
            {
                 "message":"The phone number is not whitelisted",
                 "locations":[
                     {
                         "line":2,
                         "column":3
                     }
                 ],
                 "path":[
                     "register"
                 ],
                 "extensions":{
                     "id":"029f0b7517ea137d39a946b02f4158d3",
                     "status":"NOT_WHITELISTED",
                     "statusCode":403,
                     "message":"The phone number is not whitelisted",
                     "errors":[],
                     "data":{}
                 }
            }
            """
        )
    }
}

