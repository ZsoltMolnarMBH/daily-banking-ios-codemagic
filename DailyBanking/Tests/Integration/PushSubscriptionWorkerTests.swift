//
//  PushSubscriptionWorkerTests.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 08. 31..
//

import XCTest
import Combine
import BankAPI
import Resolver
import SwiftyMocky
@testable import DailyBanking

class PushSubscriptionWorkerTests: BaseTestCase {
    private let apiMock = APIProtocolMock()
    private let subscriptionStore = PushSubscriptionMemoryStore(state: nil)
    private let mockAccessToken = CurrentValueSubject<Token?, Never>(.init(accessToken: "asd", refreshToken: "dsa"))
    private let mockAuthState = CurrentValueSubject<AuthState, Never>(.initial)
    private let mockCurrentToken = CurrentValueSubject<String?, Never>("123")
    private var disposeBag: Set<AnyCancellable>!
    private var sut: PushSubscriptionWorker!

    override func setUp() {
        // Testing in an isolated container
        container = Resolver()
        disposeBag = Set<AnyCancellable>()
        container.register { MockConfig() as PushSubscriptionConfig }
        container.register { self.apiMock as APIProtocol }
        container.register {
            self.subscriptionStore
        }
        .implements((any PushSubscriptionStore).self)
        container.register(ReadOnly<Token?>.self) { container in
            ReadOnly(stateSubject: self.mockAccessToken)
        }
        container.register(ReadOnly<AuthState>.self) {
            ReadOnly(stateSubject: self.mockAuthState)
        }
        container.register(name: .app.pushToken) {
            ReadOnly(stateSubject: self.mockCurrentToken)
        }
        container.registerInContext {
            PushSubscriptionWorker()
        }
    }

    private struct MockConfig: PushSubscriptionConfig {
        let pushSubscriptionRetryDelay: Double = 0.2
    }

    override func tearDown() {
        disposeBag = nil
        sut = nil
    }

    func test_AuthInitial_NoToken() {
        // Given
        subscriptionStore.modify { $0 = nil }
        mockCurrentToken.send(nil)
        Given(
            apiMock,
            .publisher(
                for: Parameter<SetPushTokenMutation>.any,
                willReturn: .just(.success()))
        )
        let sut = container.resolve(PushSubscriptionWorker.self)

        // When
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        var result: PushSubscriptionWorker.SubscribeInstruction?
        sut.makeInstruction()
            .sink(receiveValue: { instruction in
                result = instruction
                expectation.fulfill()
            })
            .store(in: &disposeBag)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(result, .none)
    }

    func test_AuthInitial_Subscribe() {
        // Given
        let subscribedToken = "123123123"
        subscriptionStore.modify { $0 = subscribedToken }
        mockCurrentToken.send(nil)
        mockAuthState.send(.initial)
        sut = container.resolve(PushSubscriptionWorker.self)

        // When
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        var result: PushSubscriptionWorker.SubscribeInstruction?
        sut.makeInstruction()
            .sink(receiveValue: { instruction in
                result = instruction
                expectation.fulfill()
            })
            .store(in: &disposeBag)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(result, .none)
    }

    func test_AuthActivated_Subscribe() {
        // Given
        mockCurrentToken.send("123123123")
        mockAuthState.send(.activated)
        sut = container.resolve(PushSubscriptionWorker.self)

        // When
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        var result: PushSubscriptionWorker.SubscribeInstruction?
        sut.makeInstruction()
            .sink(receiveValue: { instruction in
                result = instruction
                expectation.fulfill()
            })
            .store(in: &disposeBag)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(result, .none)
    }

    func test_Authenticated_NoToken() {
        // Given
        mockCurrentToken.send(nil)
        mockAuthState.send(.authenticated)
        sut = container.resolve(PushSubscriptionWorker.self)

        // When
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        var result: PushSubscriptionWorker.SubscribeInstruction?
        sut.makeInstruction()
            .sink(receiveValue: { instruction in
                result = instruction
                expectation.fulfill()
            })
            .store(in: &disposeBag)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(result, .none)
    }


    func test_Authenticated_NoSubscription() {
        // Given
        let currentToken = "123321"
        mockCurrentToken.send(currentToken)
        mockAuthState.send(.authenticated)
        Given(
            apiMock,
            .publisher(
                for: Parameter<SetPushTokenMutation>.any,
                willReturn: .just(.success()))
        )
        sut = container.resolve(PushSubscriptionWorker.self)

        // When
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        var subscribedToken: String?
        subscriptionStore.state.publisher
            .dropFirst()
            .sink { newValue in
                expectation.fulfill()
                subscribedToken = newValue
            }
            .store(in: &disposeBag)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(subscribedToken, currentToken)
        Verify(apiMock,
               1,
               .publisher(for: Parameter<SetPushTokenMutation>.matching({ mutation in
                   return mutation.token == currentToken
               }))
        )
    }

    func test_Authenticated_NoSubscriptionRetriesErrors() {
        // Given
        let currentToken = "123321"
        mockCurrentToken.send(currentToken)
        mockAuthState.send(.authenticated)

        Given(apiMock, .publisher(
            for: Parameter<SetPushTokenMutation>.any,
            willProduce: { stubber in
                stubber.return(
                    AnyPublisher<SetPushTokenMutation.Data, Error>.error(communication: .mock.noInternet),
                    Just(SetPushTokenMutation.Data.fail())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    AnyPublisher<SetPushTokenMutation.Data, Error>.error(communication: .mock.noInternet),
                    Just(SetPushTokenMutation.Data.success())
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                )
            })
        )
        sut = container.resolve(PushSubscriptionWorker.self)

        // When
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        var subscribedToken: String?
        subscriptionStore.state.publisher
            .dropFirst()
            .sink { newValue in
                expectation.fulfill()
                subscribedToken = newValue
            }
            .store(in: &disposeBag)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(subscribedToken, currentToken)
        Verify(apiMock,
               4,
               .publisher(for: Parameter<SetPushTokenMutation>.matching({ mutation in
                   return mutation.token == currentToken
               }))
        )
    }


    func test_Authenticated_TokenChange() {
        // Given
        mockAuthState.send(.authenticated)
        let previouslySubscribedToken = "3213213"
        subscriptionStore.modify { $0 = previouslySubscribedToken }
        let currentToken = "123321"
        mockCurrentToken.send(currentToken)
        Given(
            apiMock,
            .publisher(
                for: Parameter<SetPushTokenMutation>.any,
                willReturn: .just(.success()))
        )
        sut = container.resolve(PushSubscriptionWorker.self)

        // When
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 3
        var subscribedTokens: [String?] = []
        subscriptionStore.state.publisher
            .sink { newValue in
                expectation.fulfill()
                subscribedTokens.append(newValue)
            }
            .store(in: &disposeBag)
        wait(for: [expectation], timeout: 5)
        // Then
        XCTAssertEqual(subscribedTokens, [previouslySubscribedToken, nil, currentToken])
        Verify(apiMock,
               1,
               .publisher(for: Parameter<SetPushTokenMutation>.matching({ mutation in
                   return mutation.token == nil
               }))
        )
        Verify(apiMock,
               1,
               .publisher(for: Parameter<SetPushTokenMutation>.matching({ mutation in
                   return mutation.token == currentToken
               }))
        )
    }
}

class PushSubscriptionMemoryStore: MemoryStore<String?>, PushSubscriptionStore { }

extension SetPushTokenMutation.Data {
    static func success() -> SetPushTokenMutation.Data {
        return SetPushTokenMutation.Data(setPushToken: SetPushToken(status: .ok))
    }

    static func fail() -> SetPushTokenMutation.Data {
        return SetPushTokenMutation.Data(setPushToken: SetPushToken(status: .error))
    }
}
