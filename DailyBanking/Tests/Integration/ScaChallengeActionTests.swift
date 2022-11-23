//
//  ScaChallengeActionTests.swift
//  DailyBankingTests
//
//  Created by Adrián Juhász on 2022. 07. 27..
//

import XCTest
import Combine
import SwiftyMocky
import BankAPI
import Apollo
@testable import DailyBanking

class ScaChallengeActionTests: BaseTestCase {

    var apiMock: APIProtocolMock!
    var sut: ScaChallengeActionImpl!
    var scaChallengeStore: ScaChallengeStore!
    var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()

        apiMock = .init()
        container.register { self.apiMock as APIProtocol }
        scaChallengeStore = container.resolve(ScaChallengeStore.self)

        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = ScaChallengeActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }
    
    func testGetScaChallenge_Retrieve_Success() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<GetScaChallengeListQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .just(.mock.result())))
        // When
        let output = scaChallengeStore.state.publisher
            .collectOutput(&disposeBag)
        
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        
        sut.getScaChallengeList()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                default:
                    XCTFail("Shoudln't fail")
                }
            }
            .store(in: &disposeBag)
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(output.items.count, 2)
        XCTAssertNotNil(output.items[0])
        XCTAssertNotNil(output.items[1])
        XCTAssertEqual(output.items[1].first?.userId, "321")
    }
    
    func testApproveScaChallenge_Approve_Success() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<ApproveScaChallengeMutation>.any,
            willReturn: .just(.init(approveScaChallenge: .init(status: .approved)))))
        
        scaChallengeStore.modify {
            $0 = [ScaChallenge(id: "123", userId: "", cardToken: "", merchantName: "", amount: Money(value: Decimal(1000), currency: "HUF"), challengedAtDate: Date(), expiresAfter: 300, lastDigits: "")]
        }
        
        // When
        let output = scaChallengeStore.state.publisher
            .collectOutput(&disposeBag)
        
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        
        sut.approveScaChallenge(id: "123")
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                default:
                    XCTFail("Shoudln't fail")
                }
            }
            .store(in: &disposeBag)
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(output.items.count, 2)
        XCTAssertNotNil(output.items[0])
        XCTAssertNotNil(output.items[1])
        XCTAssertEqual(output.items[1].count, 0)
    }
    
    func testDeclineScaChallenge_Decline_Success() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<DeclineScaChallengeMutation>.any,
            willReturn: .just(.init(declineScaChallenge: .init(status: .declined)))))
        
        scaChallengeStore.modify {
            $0 = [ScaChallenge(id: "123", userId: "", cardToken: "", merchantName: "", amount: Money(value: Decimal(1000), currency: "HUF"), challengedAtDate: Date(), expiresAfter: 300, lastDigits: "")]
        }
        // When
        let output = scaChallengeStore.state.publisher
            .collectOutput(&disposeBag)
        
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        
        sut.declineScaChallenge(id: "123")
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                default:
                    XCTFail("Shoudln't fail")
                }
            }
            .store(in: &disposeBag)
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(output.items.count, 2)
        XCTAssertNotNil(output.items[0])
        XCTAssertNotNil(output.items[1])
        XCTAssertEqual(output.items[1].count, 0)
    }
}
