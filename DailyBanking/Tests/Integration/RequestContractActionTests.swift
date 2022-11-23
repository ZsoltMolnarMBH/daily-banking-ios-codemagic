//
//  RequestContractActionTests.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 20..
//

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo

class RequestContractActionTests: BaseTestCase {

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

    func testRequestContract_success_noretry() {
        // Given
        let contractID = "1234-1234"
        let contractInfo = GetContractInfoQuery.Data.GetApplication.ContractInfo(
            polling: 100,
            successful: true,
            contractId: contractID,
            error: ""
        )

        let response = GetContractInfoQuery.Data.init(getApplication: .init(contractInfo: contractInfo))
        let success: AnyPublisher<GetContractInfoQuery.Data, Error> = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: success)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [AccountOpeningDraft]()
        accountOpeningDraft.publisher
            .sink { (draft: AccountOpeningDraft) in
                testResults.append(draft)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.requestContract()
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
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertTrue(testResults.count == 2)
        XCTAssertTrue(testResults[0].contractID == nil)
        XCTAssertTrue(testResults[1].contractID != nil)
    }

    func testRequestContract_success_after_2_retries() {
        // Given
        let contractID = "1234-1234"
        let response = GetContractInfoQuery.Data(
            getApplication: .init(
                contractInfo: .init(polling: -1, successful: true, contractId: contractID, error: "")
            )
        )
        let failedResponse = GetContractInfoQuery.Data(
            getApplication: .init(
                contractInfo: .init(polling: 100, successful: false, contractId: "", error: "")
            )
        )

        let success = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let failure = Just(failedResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        apiMock.sequencingPolicy = .inWritingOrder
        apiMock.stubbingPolicy = .drop
        Given(apiMock, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        Given(apiMock, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )

        Given(apiMock, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: success)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [AccountOpeningDraft]()
        accountOpeningDraft.publisher
            .sink { (draft: AccountOpeningDraft) in
                testResults.append(draft)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.requestContract()
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
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertTrue(testResults.count == 2)
        XCTAssertTrue(testResults[0].contractID == nil)
        XCTAssertTrue(testResults[1].contractID != nil)
    }
}
