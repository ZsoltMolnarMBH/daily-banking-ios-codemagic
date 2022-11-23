//
//  LoginActionTests.swift
//  DailyBankingTests
//
//  Created by Molnár Zsolt on 2021. 11. 18..
//

import XCTest
import Combine
import Resolver
import SwiftyMocky
import BankAPI
import Apollo

@testable import DailyBanking

class LoginActionTests: BaseTestCase {
    private var apiMock: APIProtocolMock!
    private var authKeyStoreMock: MemoryAuthStore!
    private var onboardingStateStoreMock: MemoryOnboardingStateStore!
    private var sut: LoginActionImpl!
    private var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = appCoordiantor
            .container
            .makeChild()
            .assembled(using: LoginAssembly())

        apiMock = APIProtocolMock()
        authKeyStoreMock = MemoryAuthStore()
        onboardingStateStoreMock = MemoryOnboardingStateStore()
        container.register { self.apiMock as APIProtocol }
        container.register { self.authKeyStoreMock as (any AuthenticationKeyStore) }
        container.register { self.onboardingStateStoreMock as (any OnboardingStateStore) }
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = LoginActionImpl()
        }
    }

    override func tearDown() {
        apiMock = nil
        authKeyStoreMock = nil
        disposeBag = nil
        sut = nil
    }

    func testLogin_success_biometrypromotion_is_required() throws {
        // Given
        let pinCode = [1, 2, 3, 4, 5, 6]
        let tokenStore = container.resolve((any TokenStore).self)
        let pinStore = container.resolve((any TemporaryPinStore).self)
        let phoneNumber = "+36201234567"

        let responseAccessToken = "asdomasdm;asd"
        let responseRefreshToken = "asnfdansflsavas"

        let mockResponse = LoginV2Query.Data(loginV2: .init(
            accessToken: responseAccessToken,
            refreshToken: responseRefreshToken))

        let response: AnyPublisher<LoginV2Query.Data, Swift.Error> = Just(mockResponse).setFailureType(to: Swift.Error.self).eraseToAnyPublisher()

        authKeyStoreMock.modify { $0 = .init(id: phoneNumber, keyFile: CryptoMock.validKeyFile()) }
        Given(
            apiMock,
            .publisher(
                for: Parameter<LoginV2Query>.any,
                cachePolicy: Parameter<CachePolicy>.any, willReturn: response
            )
        )
        onboardingStateStoreMock.modify {
            $0.isBiometricAuthPromotionRequired = true
        }

        let expectation = XCTestExpectation()

        // When
        sut.login(pin: pinCode)
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail("Response should be success")
                case .finished:
                    expectation.fulfill()
                }

            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 0.5)

        // Then
        Verify(
            apiMock,
            1,
            .publisher(
                for: Parameter<LoginV2Query>.any,
                cachePolicy: Parameter<CachePolicy>.any
            )
        )
        XCTAssertEqual(tokenStore.state.value?.accessToken, responseAccessToken)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, responseRefreshToken)
        XCTAssertEqual(pinStore.state.value, pinCode)
    }

    func testLogin_success_biometrypromotion_not_required() throws {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        let pinStore = container.resolve((any TemporaryPinStore).self)

        let phoneNumber = "+36201234567"

        let responseAccessToken = "asdomasdm;asd"
        let responseRefreshToken = "asnfdansflsavas"

        let mockResponse = LoginV2Query.Data(loginV2: .init(
            accessToken: responseAccessToken,
            refreshToken: responseRefreshToken))

        let response: AnyPublisher<LoginV2Query.Data, Swift.Error> = Just(mockResponse).setFailureType(to: Swift.Error.self).eraseToAnyPublisher()

        authKeyStoreMock.modify { $0 = .init(id: phoneNumber, keyFile: CryptoMock.validKeyFile()) }
        Given(
            apiMock,
            .publisher(
                for: Parameter<LoginV2Query>.any,
                cachePolicy: Parameter<CachePolicy>.any, willReturn: response
            )
        )
        onboardingStateStoreMock.modify {
            $0.isBiometricAuthPromotionRequired = false
        }

        let expectation = XCTestExpectation()

        // When
        sut.login(pin: [1, 2, 3, 4, 5, 6])
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail("Response should be success")
                case .finished:
                    expectation.fulfill()
                }

            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(
            apiMock,
            1,
            .publisher(
                for: Parameter<LoginV2Query>.any,
                cachePolicy: Parameter<CachePolicy>.any
            )
        )
        XCTAssertEqual(tokenStore.state.value?.accessToken, responseAccessToken)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, responseRefreshToken)
        XCTAssertNil(pinStore.state.value)
    }

    func testLogin_keyfile_is_not_exists() throws {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        let expectation = XCTestExpectation()

        // When
        sut.login(pin: [1, 2, 3, 4, 5, 6])
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if case .action(let loginError) = error, case .keyfileMissing = loginError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                case .finished:
                    XCTFail("Response should be failed")
                }

            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 0, .publisher(for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value?.accessToken, nil)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, nil)
    }

    func testLogin_keydecryption_fails() throws {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        let phoneNumber = "+36201234567"
        let keyFile = KeyFile(encryptedKey: Data(), iv: Data(), salt: Data(), ocraSuite: "", ocraPassword: "", expirationDate: 1)
        authKeyStoreMock.modify { $0 = .init(id: phoneNumber, keyFile: keyFile) }

        let expectation = XCTestExpectation()

        // When
        sut.login(pin: [1, 2, 3, 4, 5, 6])
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if case .unknown(let unknownError) = error,
                        let cryptoError = unknownError as? CryptoOtpGen.Error,
                        case .storedKeyAesDecrypt = cryptoError {
                        expectation.fulfill()
                    }
                case .finished:
                    XCTFail("Response should be failed")
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(
            apiMock,
            0,
            .publisher(
                for: Parameter<LoginV2Query>.any,
                cachePolicy: Parameter<CachePolicy>.any
            )
        )
        XCTAssertEqual(tokenStore.state.value?.accessToken, nil)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, nil)
    }

    func testLogin_failed_invalidpin() throws {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        let expectation = XCTestExpectation()

        authKeyStoreMock.modify { $0 = .init(id: "+36209999999", keyFile: CryptoMock.validKeyFile()) }
        Given(apiMock, .publisher(
            for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .error(graphQL: .mock.invalidPin))
        )

        // When
        sut.login(pin: [1, 2, 3, 4, 5, 6])
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if case .action(let loginError) = error, case .invalidPin(remainingAttempts: let remaining) = loginError {
                        XCTAssertEqual(remaining, 4)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                case .finished:
                    XCTFail("Response should be failed")
                }

            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value?.accessToken, nil)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, nil)
    }

    func testLogin_failed_temporary_blocked() throws {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        let expectation = XCTestExpectation()

        authKeyStoreMock.modify { $0 = .init(id: "+36209999999", keyFile: CryptoMock.validKeyFile()) }
        Given(apiMock, .publisher(
            for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .error(graphQL: .mock.temporaryBlocked))
        )

        // When
        sut.login(pin: [1, 2, 3, 4, 5, 6])
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if case .action(let loginError) = error, case .temporaryBlocked(blockedTime: let blockedTime) = loginError {
                        XCTAssertEqual(blockedTime, 15)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                case .finished:
                    XCTFail("Response should be failed")
                }

            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value?.accessToken, nil)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, nil)
    }

    func testLogin_failed_deviceActivationRequired() throws {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        let expectation = XCTestExpectation()

        authKeyStoreMock.modify { $0 = .init(id: "+36209999999", keyFile: CryptoMock.validKeyFile()) }
        Given(apiMock, .publisher(
            for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .error(graphQL: .mock.deviceActivationRequired))
        )

        // When
        sut.login(pin: [1, 2, 3, 4, 5, 6])
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if case .action(let loginError) = error, case .deviceActivationRequired = loginError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                case .finished:
                    XCTFail("Response should be failed")
                }

            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value?.accessToken, nil)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, nil)
    }

    func testLogin_failed_generic() throws {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        let expectation = XCTestExpectation()

        let failure: AnyPublisher<LoginV2Query.Data, Error> = Fail<LoginV2Query.Data, Error>(
            outputType: LoginV2Query.Data.self,
            failure: TestError.simple
        ).eraseToAnyPublisher()

        authKeyStoreMock.modify { $0 = .init(id: "+36209999999", keyFile: CryptoMock.validKeyFile()) }
        Given(apiMock, .publisher(
            for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        // When
        sut.login(pin: [1, 2, 3, 4, 5, 6])
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if error is LoginError {
                        XCTFail("Invalid error type")
                    } else {
                        expectation.fulfill()
                    }
                case .finished:
                    XCTFail("Response should be failed")
                }

            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(for: Parameter<LoginV2Query>.any, cachePolicy: Parameter<CachePolicy>.any))
        XCTAssertEqual(tokenStore.state.value?.accessToken, nil)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, nil)
    }
}

private extension GraphQLError.Mock {
    var invalidPin: GraphQLError {
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

    var temporaryBlocked: GraphQLError {
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

    var deviceActivationRequired: GraphQLError {
        .from(string:
            """
            {
                 "message":"Please reactivate the device.",
                 "locations":[
                    {
                       "line":2,
                       "column":3
                    }
                 ],
                 "path":[
                    "login"
                 ],
                 "extensions": {
                    "id": "556cb1e1-31ba-4aab-95ab-0451c268c16e",
                    "status": "DEVICE_ACTIVATION_REQUIRED",
                    "statusCode": 403,
                    "message": "Please reactivate the device.",
                    "errors": [],
                }
            }
            """
        )
    }
}

private class MemoryAuthStore: MemoryStore<AuthenticationKey?>, AuthenticationKeyStore {
    init() {
        super.init(state: nil)
    }
}

private class MemoryOnboardingStateStore: MemoryStore<OnboardingState>, OnboardingStateStore {
    init() {
        super.init(state: .init(isBiometricAuthPromotionRequired: false, isRegistrationSuccessScreenRequired: false))
    }
}
