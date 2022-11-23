//
//  BankCardActionTests.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 04. 25..
//

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo

class BankCardActionTests: BaseTestCase {

    var apiMock: APIProtocolMock!
    var bankCardStore: (any BankCardStore)!
    var bankCardInfoStore: (any BankCardInfoStore)!
    var bankCardPinStore: (any BankCardPinStore)!
    var accountStore: (any AccountStore)!
    var sut: BankCardActionImpl!
    var bankCardState: ReadOnly<BankCard?>!
    var disposeBag: Set<AnyCancellable>!
    var cipherMock: BankCardCipherMock!

    override func setUp() {
        container = makeMainContainer()
            .makeChild()
            .assembled(using: BankCardsAssembly())

        apiMock = .init()
        container.register { self.apiMock as APIProtocol }

        bankCardStore = MemoryBankCardStore(card: nil)
        container.register { self.bankCardStore as (any BankCardStore) }
        container.register(ReadOnly<BankCard?>.self) {
            return self.container.resolve((any BankCardStore).self).state
        }

        bankCardInfoStore = MemoryBankCardInfoStore(card: .mock.generalBankCardInfo)
        container.register { self.bankCardInfoStore as (any BankCardInfoStore) }

        bankCardPinStore = MemoryBankCardPinStore(pin: nil)
        container.register { self.bankCardPinStore as (any BankCardPinStore) }

        cipherMock = .init()
        container.register { self.cipherMock as BankCardCipher }

        accountStore = MemoryAccountStore()
        container.register { self.accountStore as (any AccountStore) }

        bankCardState = container.resolve(ReadOnly<BankCard?>.self)

        disposeBag = Set<AnyCancellable>()
        container.useContext {
            sut = BankCardActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        bankCardStore = nil
        disposeBag = nil
    }

    func testCardsGet_Retrieve_Success() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<CardsGetQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .just(.mock.result())))
        // When
        let output = bankCardStore.state.publisher
            .collectOutput(&disposeBag)

        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1

        sut.requestBankCard()
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
        XCTAssertNil(output.items[0])
        XCTAssertNotNil(output.items[1])
        XCTAssertEqual(output.items[1]?.cardToken, "1234123")
        XCTAssertEqual(output.items[1]?.name, "TestName")
        XCTAssertEqual(output.items[1]?.cashWithdrawalLimit.total.value, 1_000_000)
        Verify(apiMock, 1, .publisher(for: Parameter<CardsGetQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testChangeCardLimit_Success() {
        // Given
        let changedCashWitdrawalLimitValue: Double = 923_236
        let changedPosLimitValue: Double = 1_000
        let changedVposLimitValue: Double = 230_000

        Given(apiMock, .publisher(
            for: Parameter<ChangeCardLimitMutation>.any,
               willReturn: .just(.mock.result(
                cashWitdrawalLimitValue: changedCashWitdrawalLimitValue,
                posLimitValue: changedPosLimitValue,
                vposLimitValue: changedVposLimitValue)))
        )

        Given(apiMock, .publisher(
            for: Parameter<CardsGetQuery>.any,
               cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .just(.mock.result())))

        // When
        let output = bankCardStore.state.publisher
            .collectOutput(&disposeBag)

        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 2

        sut.requestBankCard()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                default:
                    XCTFail("Shoudln't fail")
                }
            }
            .store(in: &disposeBag)

        sut.changeBankCardLimit(cashWithdrawal: changedCashWitdrawalLimitValue, pos: changedPosLimitValue, vpos: changedVposLimitValue)
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

        XCTAssertNotEqual(
            output.items[1]?.cashWithdrawalLimit.total.value,
            output.items[2]?.cashWithdrawalLimit.total.value)
        XCTAssertNotEqual(
            output.items[1]?.posLimit.total.value,
            output.items[2]?.posLimit.total.value)
        XCTAssertNotEqual(
            output.items[1]?.vposLimit.total.value,
            output.items[2]?.vposLimit.total.value)

        Verify(apiMock, 1, .publisher(for: Parameter<CardsGetQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testReorderCardsWorks() {

        // --- GIVEN

        let randomSessionKey: [UInt8] = [1,2,4,8,16,32]
        Given(cipherMock, .randomSessionKey(willReturn: randomSessionKey))

        let encryptedSessionKeyRSA = "sessionKeyRSA"
        Given(cipherMock, .encryptSessionKeyRSA(
            Parameter<[UInt8]>.value(randomSessionKey),
            willReturn: encryptedSessionKeyRSA))

        let pinCode = "0007"
        let pinCode_iv = "#55"
        Given(cipherMock, .encryptPinCode(
            pinCode: Parameter<String>.value(pinCode),
            sessionKey: Parameter<[UInt8]>.value(randomSessionKey),
            willReturn: (pinCode, pinCode_iv)))

        let transactionId = "TR-0001"
        let reorderCardMutationResponse: ReorderCardMutation.Data = .init(reorderCard: .init(transactionId: transactionId))
        Given(apiMock, .publisher(
            for: Parameter<ReorderCardMutation>.matching({
                $0.epin.pin == pinCode
                && $0.epin.iv == pinCode_iv
                && $0.encryptedKey == encryptedSessionKeyRSA
            }),
            willReturn: .just(reorderCardMutationResponse)))

        let pollingSuccessResponse: GetCardTransactionStatusQuery.Data = .init(getCardTransactionStatus: .init(result: .success))
        Given(apiMock, .publisher(
            for: Parameter<GetCardTransactionStatusQuery>.matching({
                $0.transactionId == transactionId
            }),
            cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely),
            willReturn: .just(pollingSuccessResponse)))

        let cardsGetQuery: CardsGetQuery.Data = .mock.result()
        Given(apiMock, .publisher(
            for: Parameter<CardsGetQuery>.matching({
                $0.accountId == Account.mock.jasonHUF.accountId
            }),
            cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely),
            willReturn: .just(cardsGetQuery)))

        bankCardStore.modify {
            $0 = nil
        }

        accountStore.modify {
            $0 = Account.mock.jasonHUF
        }

        // --- WHEN

        let expectation = XCTestExpectation()

        sut.reorderCard(pinCode: pinCode).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be succeeded!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(for: Parameter<ReorderCardMutation>.any))
        Verify(apiMock, 1, .publisher(for: Parameter<GetCardTransactionStatusQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testReorderCardsPollingThrows() {

        // --- GIVEN

        let randomSessionKey: [UInt8] = [1,2,4,8,16,32]
        Given(cipherMock, .randomSessionKey(willReturn: randomSessionKey))

        let encryptedSessionKeyRSA = "sessionKeyRSA"
        Given(cipherMock, .encryptSessionKeyRSA(
            Parameter<[UInt8]>.any,
            willReturn: encryptedSessionKeyRSA))

        let pinCode = "0007"
        let pinCode_iv = "#55"
        Given(cipherMock, .encryptPinCode(
            pinCode: Parameter<String>.any,
            sessionKey: Parameter<[UInt8]>.any,
            willReturn: (pinCode, pinCode_iv)))

        let transactionId = "transactionId"
        let reorderCardMutationResponse: ReorderCardMutation.Data = .init(reorderCard: .init(transactionId: transactionId))
        Given(apiMock, .publisher(
            for: Parameter<ReorderCardMutation>.any,
            willReturn: .just(reorderCardMutationResponse)))

        let pollingSuccessResponse: GetCardTransactionStatusQuery.Data = .init(getCardTransactionStatus:
                .init(
                    result: .reorderFailed,
                    error: [GetCardTransactionStatusQuery.Data.GetCardTransactionStatus.Error(code: nil, error: "RENEWAL_FAILED", message: nil, name: nil, sourceService: "", stack: nil, statusCode: nil, type: nil)]
                ))
        Given(apiMock, .publisher(
            for: Parameter<GetCardTransactionStatusQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(pollingSuccessResponse)))

        // --- WHEN

        let expectation = XCTestExpectation()

        sut.reorderCard(pinCode: pinCode).sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                switch error {
                case .action(let actionError):
                    if case .transactionRenewalFailed = actionError {
                        expectation.fulfill()
                    }
                default:
                    Failure("Invalid error occured!")
                }
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)
    }

    func testSetCardStateWorks() {

        // --- GIVEN

        let cardToken = "cardToken"
        let transactionId = "transactionId"

        let setCardStatusResponse: SetCardStatusMutation.Data = .init(setCardStatus: .init(transactionId: transactionId))
        Given(apiMock, .publisher(
            for: Parameter<SetCardStatusMutation>.matching({
                $0.cardStatus == .frozen && $0.cardToken == cardToken
            }),
            willReturn: .just(setCardStatusResponse)))

        let pollingSuccessResponse: GetCardTransactionStatusQuery.Data = .init(getCardTransactionStatus: .init(result: .success))
        Given(apiMock, .publisher(
            for: Parameter<GetCardTransactionStatusQuery>.matching({
                $0.transactionId == transactionId
            }),
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(pollingSuccessResponse)))

        bankCardStore.modify {
            $0 = BankCard.mock.cardWithState(BankCard.State.active)
        }

        // --- WHEN

        let expectation = XCTestExpectation()

        sut.setCardState(state: .frozen, cardToken: cardToken).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be succeeded!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(for: Parameter<SetCardStatusMutation>.any))
        Verify(apiMock, 1, .publisher(for: Parameter<GetCardTransactionStatusQuery>.any, cachePolicy: Parameter<CachePolicy>.any))

        XCTAssertEqual(bankCardStore.state.value?.state, .frozen)
    }

    func testRequestBankCardInfoWorks() {

        // --- GIVEN

        let cardToken = "cardToken"
        let cardNumber = "9876987698769876"
        let cvc = "987"

        cipherMock.sequencingPolicy = .inWritingOrder
        cipherMock.stubbingPolicy = .drop
        Given(cipherMock, .decryptData(
            sessionKey: Parameter<[UInt8]>.any,
            aesIv: Parameter<String>.any,
            data: Parameter<String>.any,
            willReturn: cardNumber))
        Given(cipherMock, .decryptData(
            sessionKey: Parameter<[UInt8]>.any,
            aesIv: Parameter<String>.any,
            data: Parameter<String>.any,
            willReturn: cvc))

        let randomSessionKey: [UInt8] = [1,2,4,8,16,32]
        Given(cipherMock, .randomSessionKey(willReturn: randomSessionKey))

        let encryptedSessionKeyRSA = "sessionKeyRSA"
        Given(cipherMock, .encryptSessionKeyRSA(
            Parameter<[UInt8]>.value(randomSessionKey),
            willReturn: encryptedSessionKeyRSA))

        let successQueryResponse: CardDetailsQuery.Data = .mock.cardDetails
        Given(apiMock, .publisher(
            for: Parameter<CardDetailsQuery>.matching({
                $0.encryptedKey == encryptedSessionKeyRSA
                && $0.cardToken == cardToken
            }),
            cachePolicy: Parameter<CachePolicy>.value(CachePolicy.fetchIgnoringCacheCompletely),
            willReturn: .just(successQueryResponse)))

        bankCardInfoStore.modify {
            $0 = nil
        }

        // --- WHEN

        let expectation = XCTestExpectation()

        sut.requestBankCardInfo(cardToken: cardToken).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be succeeded!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(cipherMock, 2, .decryptData(
            sessionKey: Parameter<[UInt8]>.any,
            aesIv: Parameter<String>.any,
            data: Parameter<String>.any))
        Verify(cipherMock, 1, .randomSessionKey())
        Verify(cipherMock, 1, .encryptSessionKeyRSA(Parameter<[UInt8]>.any))
        Verify(apiMock, 1, .publisher(for: Parameter<CardDetailsQuery>.any, cachePolicy: Parameter<CachePolicy>.any))

        XCTAssertNotNil(bankCardInfoStore.state.value)
        XCTAssertEqual(bankCardInfoStore.state.value?.cardNumber, cardNumber)
        XCTAssertEqual(bankCardInfoStore.state.value?.cvc, cvc)
    }

    func testRequestBankCardPinWorks() {

        // --- GIVEN

        let cardToken = "cardToken"
        let encryptedPin = "9999"
        let pin = "1234"

        Given(cipherMock, .decryptData(
            sessionKey: Parameter<[UInt8]>.any,
            aesIv: Parameter<String>.any,
            data: Parameter<String>.any,
            willReturn: encryptedPin))
        Given(cipherMock, .pinCodeFromIso2(Parameter<String>.value(encryptedPin),
            willReturn: pin))

        let randomSessionKey: [UInt8] = [1,2,4,8,16,32]
        Given(cipherMock, .randomSessionKey(willReturn: randomSessionKey))

        let encryptedSessionKeyRSA = "sessionKeyRSA"
        Given(cipherMock, .encryptSessionKeyRSA(
            Parameter<[UInt8]>.value(randomSessionKey),
            willReturn: encryptedSessionKeyRSA))

        let successQueryResponse: CardPinQuery.Data = .mock.cardPin
        Given(apiMock, .publisher(
            for: Parameter<CardPinQuery>.matching({
                $0.encryptedKey == encryptedSessionKeyRSA
                && $0.cardToken == cardToken
            }),
            cachePolicy: Parameter<CachePolicy>.value(CachePolicy.fetchIgnoringCacheCompletely),
            willReturn: .just(successQueryResponse)))

        bankCardPinStore.modify {
            $0 = nil
        }

        // --- WHEN

        let expectation = XCTestExpectation()

        sut.requestBankCardPin(cardToken: cardToken).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be succeeded!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(cipherMock, 1, .decryptData(
            sessionKey: Parameter<[UInt8]>.any,
            aesIv: Parameter<String>.any,
            data: Parameter<String>.any))
        Verify(cipherMock, 1, .pinCodeFromIso2(Parameter<String>.any))
        Verify(apiMock, 1, .publisher(for: Parameter<CardPinQuery>.any, cachePolicy: Parameter<CachePolicy>.any))

        XCTAssertNotNil(bankCardPinStore.state.value)
        XCTAssertEqual(bankCardPinStore.state.value, pin)
    }
}

extension CardsGetQuery.Data {
    static let mock = Mock()
    struct Mock { }
}

extension CardsGetQuery.Data.Mock {
    func result() -> CardsGetQuery.Data {
        let cashWithdrawalLimit = CardsGetQuery.Data.CardsGet.Limit.CashWithdrawalLimit(total: 1_000_000, remaining: 500_000, min: 1_000, max: 1_000_000)
        let posLimit = CardsGetQuery.Data.CardsGet.Limit.PosLimit(total: 1_000_000, remaining: 500_000, min: 1_000, max: 1_000_000)
        let vposLimit = CardsGetQuery.Data.CardsGet.Limit.VposLimit(total: 1_000_000, remaining: 500_000, min: 1_000, max: 1_000_000)
        let limits = CardsGetQuery.Data.CardsGet.Limit.init(cashWithdrawalLimit: cashWithdrawalLimit,
                                                            posLimit: posLimit,
                                                            vposLimit: vposLimit)
        let cardsGet = CardsGetQuery.Data.CardsGet(
            cardToken: "1234123",
            nameOnCard: "TestName",
            lastNumbers: "1245",
            type: "type",
            imageName: "",
            status: "",
            limits: limits,
            cardErrors: [],
            reordered: false
        )
        return CardsGetQuery.Data.init(cardsGet: [cardsGet])
    }
}

extension ChangeCardLimitMutation.Data {
    static let mock = Mock()
    struct Mock { }
}

extension ChangeCardLimitMutation.Data.Mock {

    func result(cashWitdrawalLimitValue: Double, posLimitValue: Double, vposLimitValue: Double) -> ChangeCardLimitMutation.Data {
        let cashWithdrawalLimit = ChangeCardLimitMutation.Data.ChangeCardLimit.CardLimit.CashWithdrawalLimit(total: cashWitdrawalLimitValue, remaining: 500_000, min: 1_000, max: 1_000_000)
        let posLimit = ChangeCardLimitMutation.Data.ChangeCardLimit.CardLimit.PosLimit(total: posLimitValue, remaining: 500_000, min: 1_000, max: 1_000_000)
        let vposLimit = ChangeCardLimitMutation.Data.ChangeCardLimit.CardLimit.VposLimit(total: vposLimitValue, remaining: 500_000, min: 1_000, max: 1_000_000)
        let assda = ChangeCardLimitMutation.Data.ChangeCardLimit.CardLimit.init(cashWithdrawalLimit: cashWithdrawalLimit,
                                                                                posLimit: posLimit,
                                                                                vposLimit: vposLimit)
        let limits = ChangeCardLimitMutation.Data.ChangeCardLimit.init(cardLimits: assda)
        return ChangeCardLimitMutation.Data.init(changeCardLimit: limits)
    }
}

extension CardDetailsQuery.Data {
    static let mock = Mock()
    struct Mock { }
}

extension CardDetailsQuery.Data.Mock {
    var cardDetails: CardDetailsQuery.Data {
        .init(cardDetails: .init(
            encryptedPan: .init(iv: "iv", data: "data"),
            encryptedCvc: .init(iv: "iv", data: "data"),
            expDate: "5005",
            nameOnCard: "nameOnCard"))
    }
}

extension CardPinQuery.Data {
    static let mock = Mock()
    struct Mock { }
}

extension CardPinQuery.Data.Mock {
    var cardPin: CardPinQuery.Data {
        .init(cardPin: .init(encryptedPin: .init(iv: "iv", data: "data")))
    }
}
