//
//  PaymentTransactionActionTests.swift
//  DailyBankingTests
//
//  Created by ALi on 2022. 06. 18..
//

import XCTest
import Combine
import SwiftyMocky
import BankAPI
import Apollo
@testable import DailyBanking
import CryptoKit

class PaymentTransactionActionTests: BaseTestCase {

    var apiMock: APIProtocolMock!
    var sut: PaymentTransactionActionImpl!
    var paymentTransactionStore: (any PaymentTransactionStore)!
    var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()

        apiMock = .init()
        container.register { self.apiMock as APIProtocol }
        paymentTransactionStore = container.resolve((any PaymentTransactionStore).self)

        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = PaymentTransactionActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    func testRefreshPaymentTransactionsFails() {

        // --- GIVEN

        let operationError = NSError(domain: "d", code: 5)
        let failedQuery: AnyPublisher<ListPaymentTransactionsQuery.Data, Error> =
            Fail<ListPaymentTransactionsQuery.Data, Error>(error: operationError).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failedQuery))

        // --- WHEN

        let expectation = XCTestExpectation()

        sut.refreshPaymentTransactions(of: Account.mock.jasonHUF).sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                switch error {
                case .unknown(let unknownError):
                    let unknownError = unknownError as NSError
                    if unknownError == operationError {
                        expectation.fulfill()
                    } else {
                        Failure("unknownError is invalid!")
                    }
                case .network, .secondLevelAuth:
                    Failure("Operation should be failed with unknownError!")
                }
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)
    }

    func testRefreshPaymentTransactionsWorks() {

        // --- GIVEN

        var response = ListPaymentTransactionsQuery.Data(unsafeResultMap: [:])
        let paymentTransactionFragment = PaymentTransactionFragment.mock.lunchWithPeter(status: .completed, rejectReason: nil)
        response.listPaymentTransactions = [
            .init(unsafeResultMap: paymentTransactionFragment.resultMap)
        ]
        let successQuery: AnyPublisher<ListPaymentTransactionsQuery.Data, Error> =
            Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: successQuery))

        // --- WHEN

        let expectation = XCTestExpectation()

        paymentTransactionStore.modify { paymentTransaction in
            paymentTransaction = []
        }

        sut.refreshPaymentTransactions(of: Account.mock.jasonHUF).sink { result in
            if case .finished = result {
                expectation.fulfill()
            } else {
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.matching({
                $0.accountId == Account.mock.jasonHUF.accountId
            }),
            cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely))
        )
        XCTAssertEqual(paymentTransactionStore.state.value.count, 1)
    }

    func testRefreshPaymentTransactionsWithSlowApiMockWorks() {

        // --- GIVEN

        var response = ListPaymentTransactionsQuery.Data(unsafeResultMap: [:])
        let paymentTransactionFragment = PaymentTransactionFragment.mock.lunchWithPeter(status: .completed, rejectReason: nil)
        response.listPaymentTransactions = [
            .init(unsafeResultMap: paymentTransactionFragment.resultMap)
        ]
        let successQuery: AnyPublisher<ListPaymentTransactionsQuery.Data, Error> =
            Just(response)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: successQuery))

        // --- WHEN

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2

        sut.refreshPaymentTransactions(of: Account.mock.jasonHUF).sink { result in
            if case .finished = result {
                expectation.fulfill()
            } else {
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        sut.refreshPaymentTransactions(of: Account.mock.jasonHUF).sink { result in
            if case .finished = result {
                expectation.fulfill()
            } else {
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1,  .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.matching({
                $0.accountId == Account.mock.jasonHUF.accountId
            }),
            cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely))
        )
        XCTAssertEqual(paymentTransactionStore.state.value.count, 1)
    }

    func testRefreshPaymentTransactionsCancellationWorks() {

        // --- GIVEN

        var response = ListPaymentTransactionsQuery.Data(unsafeResultMap: [:])
        let paymentTransactionFragment = PaymentTransactionFragment.mock.lunchWithPeter(status: .completed, rejectReason: nil)
        response.listPaymentTransactions = [
            .init(unsafeResultMap: paymentTransactionFragment.resultMap)
        ]
        let successQuery: AnyPublisher<ListPaymentTransactionsQuery.Data, Error> =
            Just(response)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: successQuery))

        // --- WHEN

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1

        let refreshPublisher = sut.refreshPaymentTransactions(of: Account.mock.jasonHUF).sink { _ in
            Failure("Operation should be cancelled!")
        }
        refreshPublisher.cancel()

        sut.refreshPaymentTransactions(of: Account.mock.jasonHUF).sink { result in
            if case .finished = result {
                expectation.fulfill()
            } else {
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 2,  .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.matching({
                $0.accountId == Account.mock.jasonHUF.accountId
            }),
            cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely))
        )
        XCTAssertEqual(paymentTransactionStore.state.value.count, 1)
    }

    func testRefreshPaymentTransactionsWithMoreSubscribersWorks() {

        // --- GIVEN

        var response = ListPaymentTransactionsQuery.Data(unsafeResultMap: [:])
        let paymentTransactionFragment = PaymentTransactionFragment.mock.lunchWithPeter(status: .completed, rejectReason: nil)
        response.listPaymentTransactions = [
            .init(unsafeResultMap: paymentTransactionFragment.resultMap)
        ]
        let successQuery: AnyPublisher<ListPaymentTransactionsQuery.Data, Error> =
            Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        apiMock.stubbingPolicy = .drop
        Given(apiMock, .publisher(
            for: Parameter<ListPaymentTransactionsQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: successQuery))

        // --- WHEN

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2

        let publisher = sut.refreshPaymentTransactions(of: Account.mock.jasonHUF)

        publisher.sink { result in
            if case .finished = result {
                expectation.fulfill()
            } else {
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        publisher.sink { result in
            if case .finished = result {
                expectation.fulfill()
            } else {
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)
    }
}
