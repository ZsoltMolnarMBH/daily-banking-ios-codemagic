//
//  ApplicationActionTests.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 02..
//

import Foundation
import XCTest
import Combine
import Resolver
import SwiftyMocky
import BankAPI
import Apollo
@testable import DailyBanking

class ApplicationActionTests: BaseTestCase {

    var apiMock: APIProtocolMock!
    var sut: ApplicationActionImpl!
    var accountOpeningDraftStore: (any AccountOpeningDraftStore)!
    var accountOpeningDraft: ReadOnly<AccountOpeningDraft>!
    var individualStore: (any IndividualStore)!
    var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()
            .makeChild()
            .assembled(using: AccountOpeningAssembly())

        apiMock = .init()
        container.register { self.apiMock as APIProtocol }
        accountOpeningDraftStore = MemoryAccountOpeningDraftStore(state: .init(nextStep: .unknown))
        container.register { self.accountOpeningDraftStore as (any AccountOpeningDraftStore) }
        accountOpeningDraft = container.resolve(ReadOnly<AccountOpeningDraft>.self)
        individualStore = container.resolve((any IndividualStore).self)
        disposeBag = Set<AnyCancellable>()
        container.useContext {
            sut = ApplicationActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
    }

    func testRefreshApplicationWorks() {

        // --- GIVEN

        let getApplicationQueryData = GetApplicationQuery.Data(getApplication: testGetApplicationData)

        Given(apiMock, .publisher(
            for: Parameter<GetApplicationQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(getApplicationQueryData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.refreshApplication().sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        XCTAssertEqual(accountOpeningDraft.value.nextStep, .accountOpening)
        XCTAssertEqual(accountOpeningDraft.value.selectedProduct, testGetApplicationData.selectedProduct)
        XCTAssertEqual(accountOpeningDraft.value.statements, AccountOpeningDraft.Statements.mock.testStatement)
        XCTAssertEqual(
            accountOpeningDraft.value.signInfo?.signedAt,
            DateFormatter.simple.date(optional: testGetApplicationData.signInfo!.signedAt!))
        XCTAssertEqual(accountOpeningDraft.value.contractID, testGetApplicationData.contractInfo?.fragments.contractInfoFragment.contractId)
        XCTAssertEqual(accountOpeningDraft.value.individual, Individual.mock.johnDoe)
    }

    func testSelectProductWorks() {

        // --- GIVEN

        let product = "testProduct"
        accountOpeningDraftStore.modify {
            $0 = .init(nextStep: .accountOpening, selectedProduct: "-")
        }

        let responseData: UpdateApplicationMutation.Data = .init(updateApplication: .init(status: .ok))
        Given(apiMock, .publisher(
            for: Parameter<UpdateApplicationMutation>.any,
            willReturn: .just(responseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.selectProduct(with: product).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(for: Parameter<UpdateApplicationMutation>.matching({
            $0.application.selectedProduct == product
        })))
        XCTAssertEqual(accountOpeningDraft.value.selectedProduct, product)
    }

    func testSelectProductThrows() {

        // --- GIVEN

        let product = "testProduct"

        let responseData: UpdateApplicationMutation.Data = .init(updateApplication: .init(status: .error))
        Given(apiMock, .publisher(
            for: Parameter<UpdateApplicationMutation>.any,
            willReturn: .just(responseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.selectProduct(with: product).sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                if case .unknown(let unknownError) = error,
                   let responseStatusError = unknownError as? ResponseStatusError,
                   responseStatusError == .statusFailed {
                    expectation.fulfill()
                } else {
                    Failure("Operation should be failed with ResponseStatusError.statusFailed")
                }
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(for: Parameter<UpdateApplicationMutation>.matching({
            $0.application.selectedProduct == product
        })))
        XCTAssertEqual(accountOpeningDraft.value.selectedProduct, product)
    }

    func testUpdateStatementsWorks() {

        // --- GIVEN

        let responseData: UpdateApplicationMutation.Data = .init(updateApplication: .init(status: .ok))
        Given(apiMock, .publisher(
            for: Parameter<UpdateApplicationMutation>.any,
            willReturn: .just(responseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.updateStatements(with: .mock.testStatement, kycSurvey: .mock.testKycSurvey).sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        let expectedConsentInfo = ConsentInfoInput.mock.testConsentInfoInput
        let expectedKycSurveyInfo = KycSurveyInput.mock.testKycSurveyInput
        let expectedDmStatement = testDMStatementInput
        Verify(apiMock, 1, .publisher(for: Parameter<UpdateApplicationMutation>.matching({ input in
            input.application.consentInfo == expectedConsentInfo
            && input.application.kycSurvey == expectedKycSurveyInfo
            && input.application.dmStatement == expectedDmStatement
        })))
    }

    func testUpdateStatementsThrows() {

        // --- GIVEN

        let responseData: UpdateApplicationMutation.Data = .init(updateApplication: .init(status: .error))
        Given(apiMock, .publisher(
            for: Parameter<UpdateApplicationMutation>.any,
            willReturn: .just(responseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.updateStatements(with: .mock.testStatement, kycSurvey: .mock.testKycSurvey).sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                if case .unknown(let unknownError) = error,
                   let responseStatusError = unknownError as? ResponseStatusError,
                   responseStatusError == .statusFailed {
                    expectation.fulfill()
                } else {
                    Failure("Operation should be failed with ResponseStatusError.statusFailed")
                }
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(for: Parameter<UpdateApplicationMutation>.any))
    }

    func testSignContractWorks() {

        // --- GIVEN

        let responseData: UpdateApplicationMutation.Data = .init(updateApplication: .init(status: .ok))
        Given(apiMock, .publisher(
            for: Parameter<UpdateApplicationMutation>.any,
            willReturn: .just(responseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.signContract().sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(for: Parameter<UpdateApplicationMutation>.matching({
            $0.application.signInfo == .init(isSigned: true, signedAt: DateFormatter.simple.string(from: Date()))
        })))
    }

    func testSignContractThrows() {

        // --- GIVEN

        let responseData: UpdateApplicationMutation.Data = .init(updateApplication: .init(status: .error))
        Given(apiMock, .publisher(
            for: Parameter<UpdateApplicationMutation>.any,
            willReturn: .just(responseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.signContract().sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                if case .unknown(let unknownError) = error,
                   let responseStatusError = unknownError as? ResponseStatusError,
                   responseStatusError == .statusFailed {
                    expectation.fulfill()
                } else {
                    Failure("Operation should be failed with ResponseStatusError.statusFailed")
                }
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(for: Parameter<UpdateApplicationMutation>.any))
    }

    func testRequestConractWorks() {

        // --- GIVEN

        let contractId = "12345"
        let failedResponseData: GetContractInfoQuery.Data = .init(
            getApplication: .init(
                contractInfo: .init(polling: 0.1, successful: false, contractId: contractId, error: nil)))
        let successResponseData: GetContractInfoQuery.Data = .init(
            getApplication: .init(
                contractInfo: .init(polling: 0.1, successful: true, contractId: contractId, error: nil)))
        apiMock.sequencingPolicy = .inWritingOrder
        apiMock.stubbingPolicy = .drop
        Given(apiMock, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(failedResponseData)))
        Given(apiMock, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(successResponseData)))

        accountOpeningDraftStore.modify {
            $0 = .init(nextStep: .accountOpening)
        }

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.requestContract().sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 2, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.matching({
                $0 == .fetchIgnoringCacheCompletely
            })))
        XCTAssertEqual(accountOpeningDraft.value.contractID, contractId)
    }

    func testRequestConractThrows() {

        // --- GIVEN

        let failedResponseData: GetContractInfoQuery.Data = .init(
            getApplication: .init(
                contractInfo: .init(polling: 0, successful: false, contractId: "12345", error: "SOME_ERROR")))
        Given(apiMock, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(failedResponseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.requestContract().sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                if case .action(let actionError) = error, actionError == .contractCreationFailed {
                    expectation.fulfill()
                } else {
                    Failure("Operation should be failed with contractCreationFailed")
                }
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(
            for: Parameter<GetContractInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any))
    }

    func testRequestAccountWorks() {

        // --- GIVEN

        let accountId = "12345"
        let failedResponseData: GetAccountInfoQuery.Data = .init(getApplication: .init(accountInfo: .init(polling: 0.1, successful: false, accountId: nil, error: nil)))
        let successResponseData: GetAccountInfoQuery.Data = .init(getApplication: .init(accountInfo: .init(polling: 0.1, successful: true, accountId: accountId, error: nil)))
        apiMock.sequencingPolicy = .inWritingOrder
        apiMock.stubbingPolicy = .drop
        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(failedResponseData)))
        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(successResponseData)))

        accountOpeningDraftStore.modify {
            $0 = .init(nextStep: .accountOpening)
        }

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.requestAccount().sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure:
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 2, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.matching({
                $0 == .fetchIgnoringCacheCompletely
            })))
        XCTAssertEqual(accountOpeningDraft.value.accountID, accountId)
    }

    func testRequestAccountThrows() {

        // --- GIVEN

        let failedResponseData: GetAccountInfoQuery.Data = .init(
            getApplication: .init(
                accountInfo: .init(polling: 0, successful: false, accountId: nil, error: "SOME_ERROR")))
        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(failedResponseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.requestAccount().sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                if case .action(let actionError) = error, actionError == .accountCreationTemporarilyFailed {
                    expectation.fulfill()
                } else {
                    Failure("Operation should be failed with accountCreationTemporarilyFailed")
                }
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any))
    }

    func testRequestBlockedAccountThrows() {

        // --- GIVEN

        let failedResponseData: GetAccountInfoQuery.Data = .init(
            getApplication: .init(
                accountInfo: .init(polling: 0, successful: false, accountId: nil, error: "BLOCKED_ERROR")))
        Given(apiMock, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(failedResponseData)))

        // --- WHEN

        let expectation = XCTestExpectation()
        sut.requestAccount().sink { result in
            switch result {
            case .finished:
                Failure("Operation should be failed!")
            case .failure(let error):
                if case .action(let actionError) = error, actionError == .accountCreationBlocked {
                    expectation.fulfill()
                } else {
                    Failure("Operation should be failed with accountCreationBlocked")
                }
            }
        }.store(in: &disposeBag)

        // -- THEN

        wait(for: [expectation], timeout: 4)

        Verify(apiMock, 1, .publisher(
            for: Parameter<GetAccountInfoQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any))
    }

    func testResendVerificationEmailWorks() {
        var emailOperationBlockedUntilValue: Date? = nil

        Given(apiMock, .publisher(for: Parameter<ResendVerificationEmailQuery>.any,
                                  cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely),
                                  willReturn: .just(ResendVerificationEmailQuery.Data(getVerificationEmail: .init(nextRequestInterval: 10)))))
        
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3

        accountOpeningDraft.publisher.sink { (draft: AccountOpeningDraft) in
            emailOperationBlockedUntilValue = draft.emailOperationBlockedUntil
            expectation.fulfill()
        }.store(in: &disposeBag)

        sut.resendVerificationEmail().sink { result in
            if case .finished = result {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        XCTAssertTrue(emailOperationBlockedUntilValue != nil)
    }

    func testpollingEmailVerifiedWorks() {

        apiMock.sequencingPolicy = .inWritingOrder
        apiMock.stubbingPolicy = .drop

        Given(apiMock,
            .publisher(
                for: Parameter<GetEmailVerifiedQuery>.any,
                cachePolicy: Parameter<CachePolicy>.any,
                willReturn: .just(GetEmailVerifiedQuery.Data(getIndividual: .init(mainEmail: .init(verified: false))))))
        Given(apiMock,
            .publisher(
                for: Parameter<GetEmailVerifiedQuery>.any,
                cachePolicy: Parameter<CachePolicy>.any,
                willReturn: .just(GetEmailVerifiedQuery.Data(getIndividual: .init(mainEmail: .init(verified: true))))))

        let expectation = XCTestExpectation()
        sut.pollingEmailVerified(delay: 0.1).sink { result in
            expectation.fulfill()
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 2, .publisher(for: Parameter<GetEmailVerifiedQuery>.any, cachePolicy: Parameter<CachePolicy>.any))
    }

    func testChangeEmailAddressWorks() {
        var emailOperationBlockedUntilValue: Date? = nil

        let expectedEmailAddress = "new@me.com"
        var updatedEmailAddress: String?

        Given(apiMock,
              .publisher(for: Parameter<ChangeEmailMutation>.matching({
                  $0.email == expectedEmailAddress
              }), willReturn: .just(ChangeEmailMutation.Data(changeEmail: .init(nextRequestInterval: 10)))))

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        expectation.assertForOverFulfill = true

        individualStore.modify {
            $0 = .init(phoneNumber: "", email: .init(address: "", isVerified: false))
        }

        individualStore.state.publisher.dropFirst().sink { (individual: Individual?) in
            updatedEmailAddress = individual?.email.address
            expectation.fulfill()
        }.store(in: &disposeBag)

        accountOpeningDraft.publisher.dropFirst().sink { (draft: AccountOpeningDraft) in
            emailOperationBlockedUntilValue = draft.emailOperationBlockedUntil
            expectation.fulfill()
        }.store(in: &disposeBag)

        sut.changeEmailAddress(email: expectedEmailAddress).sink { result in
            expectation.fulfill()
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        XCTAssertTrue(emailOperationBlockedUntilValue != nil)
        XCTAssertEqual(expectedEmailAddress, updatedEmailAddress)
    }
}

private let testGetApplicationData: GetApplicationQuery.Data.GetApplication = {
    .init(
        nextStep: .accountOpening,
        selectedProduct: "product",
        individual: .init(unsafeResultMap: IndividualFragment.mock.johnDoe.resultMap),
        consentInfo: .init(unsafeResultMap: ConsentFragment.mock.testStatementFragment.resultMap),
        kycSurvey: .init(unsafeResultMap: KycSurveyFragment.mock.testKycSurveyFragment.resultMap),
        contractInfo: .init(polling: 1, successful: true, contractId: "contractId", error: nil),
        signInfo: .init(signedAt: "2022-01-01"),
        dmStatement: .init(push: true, email: false, robinson: true))
}()

private let testDMStatementInput: DmStatementInput = {
    .init(push: true, email: false, robinson: true)
}()

extension PlanInput: Equatable {
    public static func == (lhs: PlanInput, rhs: PlanInput) -> Bool {
        lhs.amountFrom == rhs.amountFrom
        && lhs.amountTo == rhs.amountTo
        && lhs.currency == rhs.currency
    }
}

extension IncomingSourcesInput: Equatable {
    public static func == (lhs: IncomingSourcesInput, rhs: IncomingSourcesInput) -> Bool {
        lhs.salary == rhs.salary
        && lhs.other == rhs.other
    }
}

extension KycSurveyInput: Equatable {
    public static func == (lhs: KycSurveyInput, rhs: KycSurveyInput) -> Bool {
        lhs.depositPlan == rhs.depositPlan
        && lhs.incomingSources == rhs.incomingSources
        && lhs.transferPlan == rhs.transferPlan
    }
}

extension ConsentInfoInput: Equatable {
    public static func == (lhs: ConsentInfoInput, rhs: ConsentInfoInput) -> Bool {
        lhs.isPep == rhs.isPep
        && lhs.acceptTerms == rhs.acceptTerms
        && lhs.acceptConditions == rhs.acceptConditions
        && lhs.acceptPrivacyPolicy == rhs.acceptPrivacyPolicy
        && lhs.taxation == rhs.taxation
    }
}

extension TaxationInput: Equatable {
    public static func == (lhs: TaxationInput, rhs: TaxationInput) -> Bool {
        lhs.taxNumber == rhs.taxNumber && lhs.country == rhs.country
    }
}

extension DmStatementInput: Equatable {
    public static func == (lhs: DmStatementInput, rhs: DmStatementInput) -> Bool {
        lhs.robinson == rhs.robinson && lhs.email == rhs.email && lhs.push == rhs.push
    }
}

extension SignInfoInput: Equatable {
    public static func == (lhs: SignInfoInput, rhs: SignInfoInput) -> Bool {
        lhs.isSigned == rhs.isSigned && lhs.signedAt == rhs.signedAt
    }
}
