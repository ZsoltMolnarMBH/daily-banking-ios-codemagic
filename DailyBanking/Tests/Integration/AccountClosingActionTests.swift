//
//  AccountClosingActionTests.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 31..
//

import XCTest
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo
import Combine
import SwiftUI

class AccountClosingActionTests: BaseTestCase {

    var apiMock: APIProtocolMock!
    var sut: AccountClosingActionImpl!
    var accountClosingDraftStore: (any AccountClosingDraftStore)!
    var accountClosingDraft: ReadOnly<AccountClosingDraft>!
    var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()
            .makeChild()
            .assembled(using: AccountClosingAssembly())

        apiMock = .init()
        container.register { self.apiMock as APIProtocol }

        accountClosingDraftStore = container.resolve((any AccountClosingDraftStore).self)
        accountClosingDraft = container.resolve(ReadOnly<AccountClosingDraft>.self)
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = AccountClosingActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    func testCreateAccountClosureStatementWorks() {
        // --- GIVEN
        let accountId = "id-5"
        let expiresDateString = "2022-01-01T08:00:01Z"
        let contractId = UUID().uuidString
        let polling = 2.5

        let stillPendingResponse = GetAccountClosureStatementQuery.Data(
            getAccountClosureStatement: .init(
                expiresAt: expiresDateString,
                contractInfo: .init(
                    polling: polling,
                    contractId: nil,
                    successful: true,
                    error: nil)))
        let completedResponse = GetAccountClosureStatementQuery.Data(
            getAccountClosureStatement: .init(
                expiresAt: expiresDateString,
                contractInfo: .init(
                    polling: polling,
                    contractId: contractId,
                    successful: true,
                    error: nil)))
        let pendingQuery: AnyPublisher<GetAccountClosureStatementQuery.Data, Error> = Just(stillPendingResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        let completedQuery: AnyPublisher<GetAccountClosureStatementQuery.Data, Error> = Just(completedResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        apiMock.sequencingPolicy = .inWritingOrder
        apiMock.stubbingPolicy = .drop

        Given(apiMock, .publisher(
            for: Parameter<GetAccountClosureStatementQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: pendingQuery))
        Given(apiMock, .publisher(
            for: Parameter<GetAccountClosureStatementQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: completedQuery))

        let response = CreateAccountClosureStatementMutation.Data(createAccountClosureStatement: .init(status: .ok))
        let successOperation: AnyPublisher<CreateAccountClosureStatementMutation.Data, Error> = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<CreateAccountClosureStatementMutation>.any,
            willReturn: successOperation))

        // --- WHEN
        let expectation = XCTestExpectation()

        sut.createAccountClosureStatement(accountId: accountId, pollingInterval: 0.1).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Result should be success.")
            }
        } receiveValue: { _ in }.store(in: &disposeBag)

        // --- THEN
        wait(for: [expectation], timeout: 2)

        Verify(apiMock, 1, .publisher(
            for: Parameter<CreateAccountClosureStatementMutation>.matching({ $0.input.accountId == accountId }))
        )
        Verify(apiMock, 2, .publisher(
            for: Parameter<GetAccountClosureStatementQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )

        XCTAssertEqual(accountClosingDraft.value.withdrawalStatementContractId, contractId)
    }

    func testCreateAccountClosureStatementFails() {
        // --- GIVEN
        let accountId = "id-5"

        let response = CreateAccountClosureStatementMutation.Data(createAccountClosureStatement: .init(status: .error))
        let successOperation: AnyPublisher<CreateAccountClosureStatementMutation.Data, Error> = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<CreateAccountClosureStatementMutation>.any,
            willReturn: successOperation))

        // --- WHEN
        let expectation = XCTestExpectation()

        sut.createAccountClosureStatement(accountId: accountId, pollingInterval: 0.1).sink { result in
            switch result {
            case .finished:
                Failure("Result should be failure.")
            case .failure(let error):
                guard case ActionError.unknown(let responseError) = error, case ResponseStatusError.statusFailed = responseError else {
                    Failure("Result has invalid error.")
                }
                expectation.fulfill()
            }
        } receiveValue: { _ in }.store(in: &disposeBag)

        // --- THEN
        wait(for: [expectation], timeout: 2)
    }

    func testPollingAccountClosureCreatedFails() {
        // --- GIVEN
        let pollingErrorMessage = "Something wrong..."
        let queryResponse = GetAccountClosureStatementQuery.Data(
            getAccountClosureStatement: .init(
                expiresAt: "2022-01-01T08:00:01Z",
                contractInfo: .init(
                    polling: 2,
                    contractId: nil,
                    successful: true,
                    error: pollingErrorMessage)))
        let failedQuery: AnyPublisher<GetAccountClosureStatementQuery.Data, Error> = Just(queryResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetAccountClosureStatementQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failedQuery))

        let response = CreateAccountClosureStatementMutation.Data(createAccountClosureStatement: .init(status: .ok))
        let successOperation: AnyPublisher<CreateAccountClosureStatementMutation.Data, Error> = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        Given(apiMock, .publisher(
            for: Parameter<CreateAccountClosureStatementMutation>.any,
            willReturn: successOperation))

        // --- WHEN
        let expectation = XCTestExpectation()

        sut.createAccountClosureStatement(accountId: "5", pollingInterval: 0.1).sink { result in
            switch result {
            case .finished:
                Failure("Result should be failure.")
            case .failure(let error):
                guard case ActionError.action(let actionError) = error,
                      case AccountClosingError.pollingError(let errorMessage) = actionError,
                      errorMessage == pollingErrorMessage  else {
                    Failure("Failure should be pollingError.")
                }

                expectation.fulfill()
            }
        }.store(in: &disposeBag)

        // --- THEN
        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(
            for: Parameter<CreateAccountClosureStatementMutation>.any)
        )
        Verify(apiMock, 1, .publisher(
            for: Parameter<GetAccountClosureStatementQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any))
    }

    func testCloseAccountWorks() {
        // --- GIVEN
        let accountId = "acc-5"
        let response = CloseAccountMutation.Data(closeAccount: .init(unsafeResultMap: mockAccountFragment.resultMap))
        let successOperation: AnyPublisher<CloseAccountMutation.Data, Error> = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<CloseAccountMutation>.any,
            willReturn: successOperation))

        accountClosingDraftStore.modify { draft in
            draft.transferAccount = "1111111122222222"
            draft.comment = "some comment..."
            draft.reason = .badSupport
        }

        // --- WHEN
        let expectation = XCTestExpectation()

        sut.closeAccount(accountId: accountId).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Result should be success.")
            }
        }.store(in: &disposeBag)

        // --- THEN
        wait(for: [expectation], timeout: 2)

        Verify(apiMock, 1, .publisher(
            for: Parameter<CloseAccountMutation>.matching({
                $0.input.accountId == accountId
                && $0.input.disbursementAccountNumber == self.accountClosingDraftStore.state.value.transferAccount
                && $0.input.feedback??.comment == self.accountClosingDraftStore.state.value.comment
                && $0.input.feedback??.code == .init(from: self.accountClosingDraftStore.state.value.reason)
            })))
    }

    func testCloseAccountWithoutFeedbackWorks() {
        // --- GIVEN
        let accountId = "acc-5"
        let response = CloseAccountMutation.Data(closeAccount: .init(unsafeResultMap: mockAccountFragment.resultMap))
        let successOperation: AnyPublisher<CloseAccountMutation.Data, Error> = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<CloseAccountMutation>.any,
            willReturn: successOperation))

        accountClosingDraftStore.modify { draft in
            draft.transferAccount = "1111111122222222"
            draft.comment = nil
            draft.reason = nil
        }

        // --- WHEN
        let expectation = XCTestExpectation()

        sut.closeAccount(accountId: accountId).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Result should be success.")
            }
        }.store(in: &disposeBag)

        // --- THEN
        wait(for: [expectation], timeout: 2)

        Verify(apiMock, 1, .publisher(
            for: Parameter<CloseAccountMutation>.matching({
                $0.input.accountId == accountId
                && $0.input.disbursementAccountNumber == self.accountClosingDraftStore.state.value.transferAccount
                && $0.input.feedback == nil
            })))
    }

    func testCloseAccountWithInvalidArgumentFails() {
        // --- GIVEN
        accountClosingDraftStore.modify { draft in
            draft.transferAccount = nil
            draft.comment = nil
            draft.reason = nil
        }

        // --- WHEN
        let expectation = XCTestExpectation()

        sut.closeAccount(accountId: "acc-5").sink { result in
            switch result {
            case .finished:
                Failure("Result should be success.")
            case .failure(let error):
                switch error {
                case .unknown, .network, .secondLevelAuth:
                    Failure("Failure should be ActionError<AccountClosingError>!")
                case .action(let actionError):
                    if case .invalidArgument = actionError {
                        expectation.fulfill()
                    } else {
                        Failure("Failure should be AccountClosingError.invalidArgument")
                    }
                }
            }
        }.store(in: &disposeBag)

        // --- THEN
        wait(for: [expectation], timeout: 2)
    }
}

private let mockAccountFragment: AccountFragment = {
    AccountFragment(
        id: "id",
        accountNumber: "accountNumber",
        accountId: "accountID",
        acceptedDate: "2022-06-08T17:45:29.864Z",
        accountingUnitType: .debit,
        accountingUnitSubType: .fizsz,
        currency: "HUF",
        lifecycleStatus: .active,
        swift: "swift",
        iban: "iban",
        source: .foundation,
        flags: [.accountClosing],
        limits: .init(dailyTransferLimit: .init(name: .dailyTransferLimit, value: 345, min: 4, max: 400)),
        arrearsBalance: .init(netAmount: 40.0, currency: "HUF"),
        blockedBalance: .init(netAmount: 10.0, currency: "HUF"),
        availableBalance: .init(netAmount: 20.0, currency: "HUF"),
        bookedBalance: .init(netAmount: 30.0, currency: "HUF"),
        proxyIds: []
    )
}()
