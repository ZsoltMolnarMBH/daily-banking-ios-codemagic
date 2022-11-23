//
//  RefreshTokenActionTests.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 08..
//

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo
import SwiftUI

class RefreshTokenActionTests: BaseTestCase {
    private var apiMock: APIProtocolMock!
    private var sut: RefreshTokenActionImpl!
    private var tokenStore: MemoryTokenStore!
    private var disposeBag: Set<AnyCancellable>!
    private let oldToken: Token = .init(accessToken: "oldaccesToken", refreshToken: "oldrefreshToken")

    override func setUp() {
        container = appCoordiantor.container

        apiMock = .init()
        tokenStore = MemoryTokenStore()
        tokenStore.modify { $0 = self.oldToken }
        container.register { self.apiMock as APIProtocol }
        container.register { self.tokenStore as any TokenStore }
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = RefreshTokenActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    func testRefreshTokens_success() {
        // Given
        let newToken: Token = .init(accessToken: "accesToken", refreshToken: "refreshToken")
        let success: AnyPublisher<RefreshTokensQuery.Data, Error> = Just(.init(getTokens: .init(accessToken: newToken.accessToken, refreshToken: newToken.refreshToken)))
            .delay(for: 0.1, scheduler: DispatchQueue(label: UUID().uuidString))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: success)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Token?]()
        tokenStore.state.publisher
            .sink { (token: Token?) in
                testResults.append(token)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.refreshTokens()
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
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertEqual(testResults.count, 2)
        XCTAssertEqual(testResults[0], oldToken)
        XCTAssertEqual(testResults[1], newToken)
    }

    func testRefreshTokens_success_withMultipleConcurrentCalls() {
        // Given
        let newToken: Token = .init(accessToken: "accesToken", refreshToken: "refreshToken")
        let success: AnyPublisher<RefreshTokensQuery.Data, Error> = Just(.init(getTokens: .init(accessToken: newToken.accessToken, refreshToken: newToken.refreshToken)))
            .delay(for: 0.1, scheduler: DispatchQueue(label: UUID().uuidString))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: success)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 6
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Token?]()
        tokenStore.state.publisher
            .sink { (token: Token?) in
                testResults.append(token)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.refreshTokens()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    Failure("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        for _ in 1...3 {
            sut.refreshTokens()
                .sink { completion  in
                    switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure:
                        Failure("Result should be success.")
                    }
                }
                .store(in: &disposeBag)
        }

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertEqual(testResults.count, 2)
        XCTAssertEqual(testResults[0], oldToken)
        XCTAssertEqual(testResults[1], newToken)
    }

    func testRefreshTokens_failure_generic() {
        // Given
        let failure: AnyPublisher<RefreshTokensQuery.Data, Error> = Fail<RefreshTokensQuery.Data, Error>(
            outputType: RefreshTokensQuery.Data.self, failure: TestError.simple
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Token?]()
        tokenStore.state.publisher
            .sink { (token: Token?) in
                testResults.append(token)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.refreshTokens()
            .sink { completion in
                switch completion {
                case .finished:
                    Failure("Result should be failed.")
                case .failure:
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertEqual(testResults.count, 1)
        XCTAssertEqual(testResults[0], oldToken)
    }

    func testRefreshTokens_failure_refreshtoken_expired() {
        // Given
        let failure: AnyPublisher<RefreshTokensQuery.Data, Error> = Fail<RefreshTokensQuery.Data, Error>(
            outputType: RefreshTokensQuery.Data.self,
            failure: BankAPI.Error.graphQLError(errors: [.error])
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Token?]()
        tokenStore.state.publisher
            .sink { (token: Token?) in
                testResults.append(token)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.refreshTokens()
            .sink { completion in
                switch completion {
                case .finished:
                    Failure("Result should be failed.")
                case .failure:
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<RefreshTokensQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertEqual(testResults.count, 2)
        XCTAssertEqual(testResults[0], oldToken)
        XCTAssertEqual(testResults[1], nil)
    }

}

private extension GraphQLError {
    static var error: GraphQLError {
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
                    "getTokens"
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "TOKEN_EXPIRED",
                    "statusCode": 401,
                    "message": "Wrong refresh token or user not found",
                    "errors": [],
                    "data": []
                }
            }
            """
        )
    }
}
