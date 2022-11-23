//
//  NewTransferActionTests.swift
//  DailyBankingTests
//
//  Created by Zsolt Molnár on 2022. 03. 21..
//

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo

class NewTransferActionTests: BaseTestCase {
    var apiMock: APIProtocolMock!
    var sut: NewTransferActionImpl!
    var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()
            .makeChild()
            .assembled(using: NewTransferAssembly())

        apiMock = .init()
        container.register { ReadOnly<Account?>(stateSubject: .init(.mock.jasonHUF)) }
        container.register { NewTransferConfigMock() }
        .implements(NewTransferConfig.self)
        container.register { MemoryNewTransferDraftStore(state: .mock.lunchWithPeter) }
        .implements((any NewTransferDraftStore).self)
        container.register { self.apiMock as APIProtocol }
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = .init()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    // MARK: Daily limit

    func testDailyLimit_Update_Success() {
        // Given
        let limitStore: any MoneyProcessStore = container.resolve(name: .newTransfer.limit)
        let givenLimit = Money(value: 500000, currency: "HUF")
        Given(apiMock, .publisher(
            for: Parameter<GetDailyLimitRemainingQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(.mock.result(amount: givenLimit.value.doubleValue,
                                           currencyCode: givenLimit.currency)))
        )

        // When
        let output = limitStore.state.publisher
            .collectOutput(&disposeBag)
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        sut.updateDailyLimit()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail("Shoudln't fail")
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 400)
        XCTAssertEqual(output.items.count, 3)
        XCTAssertNil(output.items[0])
        XCTAssert(output.items[1]!.isLoading)
        XCTAssertEqual(output.items[2]!.get(), givenLimit)
        Verify(apiMock, 1, .publisher(for: Parameter<GetDailyLimitRemainingQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testDailyLimit_Update_Failure() {
        // Given
        let limitStore: any MoneyProcessStore = container.resolve(name: .newTransfer.limit)
        Given(apiMock, .publisher(
            for: Parameter<GetDailyLimitRemainingQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .error(communication: .mock.noInternet))
        )

        // When
        let output = limitStore.state.publisher
            .collectOutput(&disposeBag)
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        sut.updateDailyLimit()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shoudln't finish")
                case .failure(_):
                    expectation.fulfill()
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertEqual(output.items.count, 3)
        output.verify (
            { XCTAssertNil($0) },
            { XCTAssert($0!.isLoading) },
            { XCTAssertNotNil($0?.error) }
        )
        Verify(apiMock, 1, .publisher(for: Parameter<GetDailyLimitRemainingQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    // MARK: Transaction fee

    func testTransactionFee_Fetch_Success() {
        // Given
        let givenDraft = NewTransferDraft.mock.lunchWithPeter
        let givenMoney = givenDraft.money!
        let feeStore: any MoneyProcessStore = container.resolve(name: .newTransfer.fee)
        let givenFee = Money(value: 50, currency: "HUF")
        Given(apiMock, .publisher(
            for: Parameter<GetTransactionFeeQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
                willReturn: .just(.mock.result(amount: givenFee.value.doubleValue,
                                               currencyCode: givenFee.currency)))
        )

        // When
        let output = feeStore.state.publisher
            .collectOutput(&disposeBag)
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        sut.transactionFee(for: givenMoney)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail("Shoudln't fail")
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertEqual(output.items.count, 3)
        XCTAssertNil(output.items[0])
        XCTAssert(output.items[1]!.isLoading)
        XCTAssertEqual(output.items[2]!.get(), givenFee)
        Verify(apiMock, 1, .publisher(for: Parameter<GetTransactionFeeQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testTransactionFee_Fetch_Failure() {
        // Given
        let givenDraft = NewTransferDraft.mock.lunchWithPeter
        let givenMoney = givenDraft.money!
        let feeStore: any MoneyProcessStore = container.resolve(name: .newTransfer.fee)
        Given(apiMock, .publisher(
            for: Parameter<GetTransactionFeeQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .error(communication: .mock.noInternet))
        )

        // When
        let output = feeStore.state.publisher
            .collectOutput(&disposeBag)
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        sut.transactionFee(for: givenMoney)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shoudln't succeed")
                case .failure(_):
                    expectation.fulfill()
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertEqual(output.items.count, 3)
        output.verify (
            { XCTAssertNil($0) },
            { XCTAssert($0!.isLoading) },
            { XCTAssertNotNil($0?.error) }
        )
        Verify(apiMock, 1, .publisher(for: Parameter<GetTransactionFeeQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    // MARK: Initiate new transfer

    func testInitiate_Parameters() {
        // Given
        let draft: NewTransferDraft = .mock.lunchWithPeter
        let draftStore: MemoryNewTransferDraftStore = container.resolve()
        draftStore.modify { $0 = draft }
        let account = container.resolve(ReadOnly<Account?>.self).value!
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .error(graphQL: .mock.initiateTransferFailure(with: .invalidCreditorBban)))
        )

        // When
        let expectation = XCTestExpectation()
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shouldn't finish")
                case .failure:
                    expectation.fulfill()
                }
            }, receiveValue: { result in
                XCTFail("Shouldn't receive value")
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.matching({ mutation in
            let input = mutation.input
            let debtor = input.debtor
            let creditor = input.creditor
            let instruction = input.creditInstruction
            guard debtor.identificationType == .iban && debtor.identification == account.iban else {
                return false }
            guard creditor.name == draft.beneficiary?.name
                    && creditor.account.identification == draft.beneficiary?.accountNumber
                    && creditor.account.identificationType == .bban else {
                        return false }
            guard instruction.money.currencyCode.rawValue.lowercased() == draft.money?.currency.lowercased()
                    && instruction.money.amount == draft.money?.value.doubleValue else {
                        return false }
            return true
        })))
        Verify(apiMock, 0, .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    private func performInstantRejectedTest(givenError: RejectionReason, expected: TransferRejection) {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .error(graphQL: .mock.initiateTransferFailure(with: givenError)))
        )

        // When
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        var error: ActionError<NewTransferError>?
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shouldn't finish")
                case .failure(let receivedError):
                    error = receivedError
                    expectation.fulfill()
                }
            }, receiveValue: { result in
                XCTFail("Shouldn't receive value")
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
//        guard let error = error as? NewTransferError else {
//            XCTFail("Unexpected kind of error \(String(describing: error))")
//            return
//        }
        guard case let .action(error) = error else {
            XCTFail("Unexpected kind of error \(String(describing: error))")
            return
        }
        XCTAssertEqual(error, .rejected(expected))
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.any))
        Verify(apiMock, 0, .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testInitiate_InstantRejection_invalidDebtorBBAN() {
        performInstantRejectedTest(givenError: .invalidDebtorBban, expected: .invalidDebtor)
    }

    func testInitiate_InstantRejection_invalidDebtorIBAN() {
        performInstantRejectedTest(givenError: .invalidDebtorIban, expected: .invalidDebtor)
    }

    func testInitiate_InstantRejection_invalidCreditorBBAN() {
        performInstantRejectedTest(givenError: .invalidCreditorBban, expected: .invalidCreditor)
    }

    func testInitiate_InstantRejection_invalidCreditorIBAN() {
        performInstantRejectedTest(givenError: .invalidCreditorIban, expected: .invalidCreditor)
    }

    func testInitiate_InstantRejection_noBalanceCoverage() {
        performInstantRejectedTest(givenError: .noBalanceCoverage, expected: .insufficientBalance)
    }

    func testInitiate_InstantRejection_creditorMatchesDebtor() {
        performInstantRejectedTest(givenError: .creditorAndDebtorIdentificationsAreTheSame, expected: .creditorMatchesDebtor)
    }

    func testInitiate_InstantRejection_creditorAccountNotIntrabank() {
        performInstantRejectedTest(givenError: .creditorAccountNotIntrabank, expected: .creditorAccountNotIntrabank)
    }

    func testInitiate_InstantRejection_creditorAccountClosed() {
        performInstantRejectedTest(givenError: .creditorAccountClosed, expected: .creditorAccountClosed)
    }

    func testInitiate_InstantRejection_dailyLimitReached() {
        performInstantRejectedTest(givenError: .dailyLimitReached, expected: .dailyLimitReached)
    }

    func testInitiate_InstantRejection_unknown() {
        let unknown = "asd"
        performInstantRejectedTest(givenError: .__unknown(unknown), expected: .unknown(unknown))
    }

    func testInitiate_NoInternetErrorExposed() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .error(communication: .mock.noInternet))
        )

        // When
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        var error: ActionError<NewTransferError>?
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shouldn't finish")
                case .failure(let receivedError):
                    error = receivedError
                    expectation.fulfill()
                }
            }, receiveValue: { result in
                XCTFail("Shouldn't receive value")
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssert({
            if case .network = error {
                return true
            }
            return false
        }(), "Unexpected kind of error")
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.any))
        Verify(apiMock, 0, .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testInitiate_Complete_Instantly() {
        // Given
        let givenTransferId = "pay/123"
        let givenTransaction = PaymentTransactionFragment.mock.lunchWithPeter()
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .just(InitiateNewTransferV2Mutation.initiateSuccess(id: givenTransferId)))
        )
        Given(apiMock, .publisher(
            for: Parameter<GetPaymentTransactionsQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .just(givenTransaction.wrappedGetPaymentTransactionsQuery))
        )

        // When
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        var result: NewTransferSuccess?
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Shouldn't error")
                }
            }, receiveValue: { receivedValue in
                result = receivedValue
                expectation.fulfill()
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        guard let transaction = result?.transaction else {
            XCTFail("Expected to have a result and transaction")
            return
        }
        XCTAssertEqual(transaction.accountNumber, givenTransaction.creditor.fragments.participantFragment.account.identification)
        XCTAssertEqual(transaction.name, givenTransaction.creditor.fragments.participantFragment.name)
        XCTAssertEqual(transaction.direction, .send)
        XCTAssertEqual(transaction.reference, givenTransaction.paymentReference)
        XCTAssertEqual(transaction.rejectionReason, nil)
        XCTAssertEqual(transaction.state, .completed)
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.any))
        Verify(apiMock, 1, .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testInitiate_PollingTimeout() {
        // Given
        let config: NewTransferConfig = container.resolve()
        let givenTransferId = "pay/123"
        let givenTransaction = PaymentTransactionFragment.mock.lunchWithPeter(status: .pending)
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .just(InitiateNewTransferV2Mutation.initiateSuccess(id: givenTransferId)))
        )
        Given(apiMock, .publisher(
            for: Parameter<GetPaymentTransactionsQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .just(givenTransaction.wrappedGetPaymentTransactionsQuery))
        )

        // When
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        var result: NewTransferSuccess?
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Shouldn't error")
                }
            }, receiveValue: { receivedValue in
                result = receivedValue
                expectation.fulfill()
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        guard let transaction = result?.transaction else {
            XCTFail("Expected to have a result and transaction")
            return
        }
        XCTAssertEqual(transaction.accountNumber, givenTransaction.creditor.fragments.participantFragment.account.identification)
        XCTAssertEqual(transaction.name, givenTransaction.creditor.fragments.participantFragment.name)
        XCTAssertEqual(transaction.direction, .send)
        XCTAssertEqual(transaction.reference, givenTransaction.paymentReference)
        XCTAssertEqual(transaction.rejectionReason, nil)
        XCTAssertEqual(transaction.state, .pending)
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.any))
        Verify(apiMock, .exactly(config.pollCount), .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testInitiate_Complete_AfterSomePolling() {
        // Given
        let givenTransferId = "pay/123"
        let givenTransaction = PaymentTransactionFragment.mock.lunchWithPeter()
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .just(InitiateNewTransferV2Mutation.initiateSuccess(id: givenTransferId)))
        )
        Given(apiMock, .publisher(
            for: Parameter<GetPaymentTransactionsQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willProduce: { stubber in
                   stubber.return(
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .initiated)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .pending)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .pending)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .completed)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                   )
               }))

        // When
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        expectation.assertForOverFulfill = true
        var result: NewTransferSuccess?
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Shouldn't error")
                }
            }, receiveValue: { receivedValue in
                result = receivedValue
                expectation.fulfill()
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        guard let transaction = result?.transaction else {
            XCTFail("Expected to have a result and transaction")
            return
        }
        XCTAssertEqual(transaction.accountNumber, givenTransaction.creditor.fragments.participantFragment.account.identification)
        XCTAssertEqual(transaction.name, givenTransaction.creditor.fragments.participantFragment.name)
        XCTAssertEqual(transaction.direction, .send)
        XCTAssertEqual(transaction.reference, givenTransaction.paymentReference)
        XCTAssertEqual(transaction.rejectionReason, nil)
        XCTAssertEqual(transaction.state, .completed)
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.any))
        Verify(apiMock, 4, .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testInitiate_Rejected_AfterSomePolling() {
        // Given
        let givenTransferId = "pay/123"
        let givenRejectReason = RejectionReason.creditorAccountNotIntrabank
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .just(InitiateNewTransferV2Mutation.initiateSuccess(id: givenTransferId)))
        )
        Given(apiMock, .publisher(
            for: Parameter<GetPaymentTransactionsQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willProduce: { stubber in
                   stubber.return(
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .initiated)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .pending)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .pending)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .rejected, rejectReason: givenRejectReason)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                   )
               }))

        // When
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        var error: ActionError<NewTransferError>?
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Shouldn't finish")
                case .failure(let receivedError):
                    error = receivedError
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Shouldn't receive value")
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        guard case let .action(error) = error else {
            XCTFail("Unexpected kind of error \(String(describing: error))")
            return
        }
        XCTAssertEqual(error, .rejected(.creditorAccountNotIntrabank))
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.any))
        Verify(apiMock, 4, .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testInitiate_ConnectionLoss_DuringPolling() {
        testInitiate_Error_DuringPolling(error: CommunicationError.mock.noInternet)
    }

    func testInitiate_DecodingError_DuringPolling() {
        testInitiate_Error_DuringPolling(error: GraphQLResultError.mock.decodingError)
    }

    func testInitiate_Error_DuringPolling(error: Error) {
        // Given
        let givenTransferId = "pay/123"
        Given(apiMock, .publisher(
            for: Parameter<InitiateNewTransferV2Mutation>.any,
               willReturn: .just(InitiateNewTransferV2Mutation.initiateSuccess(id: givenTransferId)))
        )
        Given(apiMock, .publisher(
            for: Parameter<GetPaymentTransactionsQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willProduce: { stubber in
                   stubber.return(
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .initiated)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .pending)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Just(PaymentTransactionFragment
                            .mock
                            .lunchWithPeter(status: .pending)
                            .wrappedGetPaymentTransactionsQuery)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher(),
                    Fail<GetPaymentTransactionsQuery.Data, Error>(
                        outputType: GetPaymentTransactionsQuery.Data.self,
                        failure: error)
                        .eraseToAnyPublisher()
                   )
               }))

        // When
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        expectation.assertForOverFulfill = true
        var result: NewTransferSuccess?
        sut.initiateNewTransfer()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Shouldn't error")
                }
            }, receiveValue: { receivedValue in
                result = receivedValue
                expectation.fulfill()
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)

        XCTAssertNotNil(result, "Expected to have a result")
        XCTAssertNil(result?.transaction)
        Verify(apiMock, 1, .publisher(for: Parameter<InitiateNewTransferV2Mutation>.any))
        Verify(apiMock, 4, .publisher(for: Parameter<GetPaymentTransactionsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }
}

extension GraphQLError.Mock {
    func initiateTransferFailure(with reason: RejectionReason) -> GraphQLError {
        .from(string:
            """
            {
              "message": "The provided creditor BBAN is invalid",
              "locations": [
                {
                  "line": 2,
                  "column": 3
                }
              ],
              "path": [
                "initiateNewTransfer"
              ],
              "extensions": {
                "id": "df9667edeb71e97c4c4139792eedd79f",
                "statusCode": 400,
                "message": "The provided creditor BBAN is invalid",
                "status": "\(reason.rawValue)"
              }
            }
            """
        )
    }
}

extension InitiateNewTransferV2Mutation {
    static func initiateSuccess(id: String) -> InitiateNewTransferV2Mutation.Data {
        .init(initiateNewTransferV2: .init(id: id))
    }
}

extension GetTransactionFeeQuery.Data {
    static let mock = Mock()
    struct Mock { }
}

extension GetTransactionFeeQuery.Data.Mock {
    func result(amount: Double, currencyCode: String) -> GetTransactionFeeQuery.Data {
        let fee = GetTransactionFeeQuery.Data.GetTransactionFee(amount: "\(amount)", currencyCode: currencyCode)
        let response = GetTransactionFeeQuery.Data(getTransactionFee: fee)
        return response
    }
}

extension GetDailyLimitRemainingQuery.Data {
    static let mock = Mock()
    struct Mock { }
}

extension GetDailyLimitRemainingQuery.Data.Mock {
    func result(amount: Double, currencyCode: String) -> GetDailyLimitRemainingQuery.Data {
        let limit = GetDailyLimitRemainingQuery.Data.GetDailyLimitRemaining(amount: "\(amount)", currencyCode: currencyCode)
        let response = GetDailyLimitRemainingQuery.Data(getDailyLimitRemaining: limit)
        return response
    }
}
