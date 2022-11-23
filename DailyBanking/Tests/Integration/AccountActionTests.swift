//
//  AccountActionTests.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 06..
//

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo

class AccountActionTests: BaseTestCase {

    var apiMock: APIProtocolMock!
    var sut: AccountActionImpl!
    var accountState: ReadOnly<Account?>!
    var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()

        apiMock = .init()
        container.register { self.apiMock as APIProtocol }

        accountState = container.resolve(ReadOnly<Account?>.self)
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = AccountActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    func testRefreshAccounts_failed_unknownError() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<AccountListQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .error(communication: .mock.noInternet))
        )

        let expectation = XCTestExpectation()

        // WHen
        sut.refreshAccounts()
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
            for: Parameter<AccountListQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
    }

    func testRefreshAccounts_success() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<AccountListQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(mockAccounts))
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Account?]()
        accountState.publisher
            .sink { (account: Account?) in
                testResults.append(account)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.refreshAccounts()
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
            for: Parameter<AccountListQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )

        XCTAssertTrue(testResults.count == 2)
        XCTAssertTrue(testResults[0] == nil)
        let mock = mockAccounts.accountsList[0].fragments.accountFragment
        XCTAssertTrue(testResults[1]?.accountNumber == mock.accountNumber)
        XCTAssertTrue(testResults[1]?.iban == mock.iban)
        XCTAssertTrue(testResults[1]?.swift == mock.swift)
        XCTAssertTrue(compare(
            decimal: testResults[1]?.availableBalance.value,
            double: mock.availableBalance.fragments.balanceFragment.netAmount
        ))
        XCTAssertEqual(testResults[1]?.availableBalance.currency, mock.availableBalance.fragments.balanceFragment.currency)
        XCTAssertTrue(compare(
            decimal: testResults[1]?.bookedBalance.value,
            double: mock.bookedBalance.fragments.balanceFragment.netAmount
        ))
        XCTAssertEqual(testResults[1]?.bookedBalance.currency, mock.bookedBalance.fragments.balanceFragment.currency)
        XCTAssertTrue(compare(
            decimal: testResults[1]?.blockedBalance.value,
            double: mock.blockedBalance.fragments.balanceFragment.netAmount
        ))
        XCTAssertEqual(testResults[1]?.blockedBalance.currency, mock.blockedBalance.fragments.balanceFragment.currency)
        XCTAssertTrue(compare(
            decimal: testResults[1]?.arrearsBalance.value,
            double: mock.arrearsBalance.fragments.balanceFragment.netAmount
        ))
        XCTAssertEqual(testResults[1]?.arrearsBalance.currency, mock.arrearsBalance.fragments.balanceFragment.currency)
    }

    func testRefreshAccounts_success_withMultipleConcurrentCalls() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<AccountListQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(mockAccounts).delay(for: 0.1, scheduler: DispatchQueue.main).eraseToAnyPublisher())
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Account?]()
        accountState.publisher
            .sink { (account: Account?) in
                testResults.append(account)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.refreshAccounts()
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
            sut.refreshAccounts()
                .sink { _ in }
                .store(in: &disposeBag)
        }

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<AccountListQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
    }

    func testRefreshAccounts_canceled() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<AccountListQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(mockAccounts).delay(for: 1, scheduler: DispatchQueue.main).eraseToAnyPublisher())
        )
        let expectation = XCTestExpectation()
        expectation.isInverted = true

        // When
        let cancellable = sut.refreshAccounts()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    expectation.fulfill()
                }
            }

        cancellable.cancel()

        wait(for: [expectation], timeout: 0.2)

        // Then
        XCTAssertTrue(accountState.value == nil)
    }

    func testAddProxyId_success() {
        // Given
        let alias = "ProxyID"
        let account = Account.mock.jasonHUF
        Given(apiMock, .publisher(
            for: Parameter<ProxyIdCreateMutation>.any,
            willReturn: .just(.init(proxyIdCreate: .init(status: .ok))))
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.addProxyId(to: account, alias: alias)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be finished.")
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(
            for: Parameter<ProxyIdCreateMutation>.matching({
                $0.bic == account.swift && $0.iban == account.iban && $0.alias == alias
            }))
        )
    }

    func testAddProxyId_failed() {
        // Given
        let alias = "ProxyID"
        let account = Account.mock.jasonHUF
        Given(apiMock, .publisher(
            for: Parameter<ProxyIdCreateMutation>.any,
            willReturn: .error(communication: .mock.noInternet))
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        sut.addProxyId(to: account, alias: alias)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failure.")
                case .failure:
                    expectation.fulfill()
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(
            for: Parameter<ProxyIdCreateMutation>.matching({
                $0.bic == account.swift && $0.iban == account.iban && $0.alias == alias
            }))
        )
    }

    func testDeleteProxyId_success() {
        // Given
        let alias = "ProxyID"
        let account = Account.mock.jasonHUF
        Given(apiMock, .publisher(
            for: Parameter<ProxyIdDeleteMutation>.any,
            willReturn: .just(.init(proxyIdDelete: .init(status: .ok))))
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        sut.deleteProxyId(from: account, alias: alias)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be finished.")
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(
            for: Parameter<ProxyIdDeleteMutation>.matching({
                $0.bic == account.swift && $0.iban == account.iban && $0.alias == alias
            }))
        )
    }

    func testDeleteProxyId_failed() {
        // Given
        let alias = "ProxyID"
        let account = Account.mock.jasonHUF
        Given(apiMock, .publisher(
            for: Parameter<ProxyIdDeleteMutation>.any,
            willReturn: .error(communication: .mock.noInternet))
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        sut.deleteProxyId(from: account, alias: alias)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failure.")
                case .failure:
                    expectation.fulfill()
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(
            for: Parameter<ProxyIdDeleteMutation>.matching({
                $0.bic == account.swift && $0.iban == account.iban && $0.alias == alias
            }))
        )
    }

    private func compare(decimal: Decimal?, double: Double?) -> Bool {
        if decimal == nil && double == nil { return true }
        guard let decimal = decimal, let double = double else { return false }
        return decimal == Decimal(double)
    }

    func testRequestSetLimit_failed() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<AccountListQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(mockAccounts))
        )

        let failureSetLimit: AnyPublisher<SetLimitMutation.Data, Error> = Fail<SetLimitMutation.Data, Error>(
            outputType: SetLimitMutation.Data.self, failure: TestError.simple
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<SetLimitMutation>.any,
               willReturn: failureSetLimit)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Account?]()

        sut.refreshAccounts()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    Failure("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        accountState.publisher
            .sink { (account: Account?) in
                testResults.append(account)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        guard let account = testResults.first, let account = account else { return }
        sut.setLimit(on: account, limitValue: 2, limitName: .dailyTransferLimit)
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

        Verify(apiMock, 1, .publisher(
            for: Parameter<SetLimitMutation>.any)
        )
    }

    func testRequestSetLimit_success() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<AccountListQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(mockAccounts))
        )

        let response = SetLimitMutation.Data(setLimit: .init(unsafeResultMap: mockAccountFragment.resultMap))
        let successSetLimit: AnyPublisher<SetLimitMutation.Data, Error> = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<SetLimitMutation>.any,
               willReturn: successSetLimit)
        )


        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 4
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Account?]()

        sut.refreshAccounts()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    Failure("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        accountState.publisher
            .sink { (account: Account?) in
                testResults.append(account)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        guard let account = testResults.first, let account = account else { return }
        sut.setLimit(on: account, limitValue: 2, limitName: .dailyTransferLimit)
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
            for: Parameter<SetLimitMutation>.any)
        )

        XCTAssertTrue(accountState.value?.limits.dailyTransferLimit.value == mockAccountFragment.limits.dailyTransferLimit.value)
        XCTAssertTrue(accountState.value?.limits.dailyTransferLimit.name == .dailyTransferLimit)
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
        flags: [],
        limits: .init(dailyTransferLimit: .init(name: .dailyTransferLimit, value: 345, min: 4, max: 400)),
        arrearsBalance: .init(netAmount: 40.0, currency: "HUF"),
        blockedBalance: .init(netAmount: 10.0, currency: "HUF"),
        availableBalance: .init(netAmount: 20.0, currency: "HUF"),
        bookedBalance: .init(netAmount: 30.0, currency: "HUF"),
        proxyIds: []
    )
}()

private let mockAccounts: AccountListQuery.Data = {
    let account = AccountListQuery.Data.AccountsList(unsafeResultMap: mockAccountFragment.resultMap)
    return AccountListQuery.Data(accountsList: [account])
}()
