//
//  RequestAccountTests.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 25..
//

import Foundation

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo

class RequestAccountActionTests: BaseTestCase {
    var apiMock: APIProtocolMock!
    var sut: ApplicationActionImpl!
    var accountOpeningDraft: ReadOnly<AccountOpeningDraft>!
    var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()
            .makeChild()
            .assembled(using: AccountOpeningAssembly())

        apiMock = .init()
        container.register { self.apiMock as APIProtocol }
        accountOpeningDraft = container.resolve(ReadOnly<AccountOpeningDraft>.self)
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = ApplicationActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    func testRequestAccount_failed_unknownError() {
        // Given
        let failure: AnyPublisher<GetAccountInfoQuery.Data, Error> = Fail<GetAccountInfoQuery.Data, Error>(
            outputType: GetAccountInfoQuery.Data.self, failure: TestError.simple
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()

        // WHen
        sut.requestAccount()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failed.")
                case .failure(let error):
                    if case .unknown(let unknownError) = error, let testError = unknownError as? TestError, testError == .simple {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
    }

    func testRequestAccount_failed_blocked_error() {
        // Given
        let blocked = GetAccountInfoQuery.Data.GetApplication.AccountInfo(
            polling: -1,
            successful: false,
            accountId: "",
            error: "BLOCKED_ERROR"
        )

        let response: AnyPublisher<GetAccountInfoQuery.Data, Error> = Just(.init(getApplication: .init(accountInfo: blocked)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: response)
        )

        let expectation = XCTestExpectation()

        // WHen
        sut.requestAccount()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failed.")
                case .failure(let error):
                    if case .action(let actionError) = error, actionError == .accountCreationBlocked {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
    }

    func testRequestAccount_failed_temporary_error() {
        // Given
        let temporary = GetAccountInfoQuery.Data.GetApplication.AccountInfo(
            polling: -1,
            successful: false,
            accountId: "",
            error: "TEMPORARY_ERROR"
        )

        let response: AnyPublisher<GetAccountInfoQuery.Data, Error> = Just(.init(getApplication: .init(accountInfo: temporary)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: response)
        )

        let expectation = XCTestExpectation()

        // WHen
        sut.requestAccount()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failed.")
                case .failure(let error):
                    if case .action(let actionError) = error, actionError == .accountCreationTemporarilyFailed {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
    }

    func testRequestAccount_success_noretry() {
        // Given
        let accountId = "accountID"
        let accountInfo = GetAccountInfoQuery.Data.GetApplication.AccountInfo(
            polling: 100,
            successful: true,
            accountId: accountId,
            error: ""
        )

        let success: AnyPublisher<GetAccountInfoQuery.Data, Error> = Just(.init(getApplication: .init(accountInfo: accountInfo)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: success)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [AccountOpeningDraft]()
        accountOpeningDraft
            .publisher
            .sink { (draft: AccountOpeningDraft) in
                testResults.append(draft)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.requestAccount()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    Failure("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )

        XCTAssertTrue(testResults.count == 2)
        XCTAssertNil(testResults[0].accountID)
        XCTAssertEqual(testResults[1].accountID, accountId)
    }

    func testRequestAccount_success_after_2_retries() {
        // Given
        let accountId = "accountID"
        let infoWithAccountId = GetAccountInfoQuery.Data.GetApplication.AccountInfo(
            polling: 100,
            successful: true,
            accountId: accountId,
            error: ""
        )

        let retry = GetAccountInfoQuery.Data.GetApplication.AccountInfo(
            polling: 100,
            successful: false,
            accountId: "",
            error: ""
        )

        let success: AnyPublisher<GetAccountInfoQuery.Data, Error> = Just(.init(getApplication: .init(accountInfo: infoWithAccountId)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let failure: AnyPublisher<GetAccountInfoQuery.Data, Error> = Just(.init(getApplication: .init(accountInfo: retry)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        apiMock.sequencingPolicy = .inWritingOrder
        apiMock.stubbingPolicy = .drop
        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: success)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [AccountOpeningDraft]()
        accountOpeningDraft
            .publisher
            .sink { (draft: AccountOpeningDraft) in
                testResults.append(draft)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.requestAccount()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    Failure("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 3, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )

        XCTAssertTrue(testResults.count == 2)
        XCTAssertNil(testResults[0].accountID)
        XCTAssertEqual(testResults[1].accountID, accountId)
    }
}
