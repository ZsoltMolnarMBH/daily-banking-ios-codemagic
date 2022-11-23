    //
//  ProfileActionTests.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 18..
//

import XCTest
import Combine
import Resolver
@testable import DailyBanking
import SwiftyMocky
import BankAPI
import Apollo
import SwiftUI

class UserActionTests: BaseTestCase {
    private var apiMock: APIProtocolMock!
    private var biometricAuthStoreMock: BiometricAuthStoreMock!
    private var sut: UserActionImpl!
    private var authKeyStoreMock: MemoryAuthStore!
    private var individualState: ReadOnly<Individual?>!
    private var userState: ReadOnly<User?>!
    private var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()

        apiMock = .init()
        biometricAuthStoreMock = .init()
        authKeyStoreMock = MemoryAuthStore()
        container.register { self.apiMock as APIProtocol }
        container.register { self.authKeyStoreMock as (any AuthenticationKeyStore) }
        container.register { self.biometricAuthStoreMock as BiometricAuthStore }
        individualState = container.resolve(ReadOnly<Individual?>.self)
        userState = container.resolve(ReadOnly<User?>.self)
        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = UserActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        disposeBag = nil
        individualState = nil
        userState = nil
    }

    func testLogout() {
        // Given
        let tokenStore = container.resolve((any TokenStore).self)
        tokenStore.modify {
            $0 = .init(accessToken: "accessToken", refreshToken: "refreshToken")
        }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.logout()
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertTrue(tokenStore.state.value == nil)
    }

    func testLoadContracts_success() {
        // Given
        let contractState = container.resolve(ReadOnly<[UserContract]>.self)
        let contract = ListContractsQuery.Data.ListContract(name: "C1", contractId: "id1", signedAt: "2021-10-05", acceptedAt: "2021-10-06", uploadedAt: "2021-10-07")
        Given(apiMock, .publisher(
            for: Parameter<ListContractsQuery>.any,
            cachePolicy: .any,
            willReturn: .just(ListContractsQuery.Data.init(listContracts: [contract])))
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.loadContracts()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        // Then
        XCTAssertTrue(contractState.value.count == 1)
        let saved = contractState.value[0]
        XCTAssertEqual(saved.title, contract.fragments.userContractFragment.name)
        XCTAssertEqual(saved.contractID, contract.fragments.userContractFragment.contractId)
        XCTAssertEqual(saved.signedAt, DateFormatter.simple.date(from: contract.fragments.userContractFragment.signedAt))
        XCTAssertEqual(saved.acceptedAt, DateFormatter.simple.date(from: contract.fragments.userContractFragment.acceptedAt))
        XCTAssertEqual(saved.uploadedAt, DateFormatter.simple.date(optional: contract.fragments.userContractFragment.uploadedAt))
    }

    func testLoadContracts_failed() {
        // Given
        let contractState = container.resolve(ReadOnly<[UserContract]>.self)
        let response = Fail<ListContractsQuery.Data, Error>(error: TestError.simple)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ListContractsQuery>.any,
            cachePolicy: .any,
            willReturn: response)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.loadContracts()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failed.")
                case .failure:
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)

        // Then
        XCTAssertTrue(contractState.value.count == 0)
    }

    func testLoadStatements_success() {
        // Given
        let statementState = container.resolve(ReadOnly<[MonthlyStatement]>.self)
        let statement = ListStatementsQuery.Data.ListStatement(statementId: "ID1", periodStart: "2021-10-01", periodEnd: "2021-10-31")
        Given(apiMock, .publisher(
            for: Parameter<ListStatementsQuery>.any,
            cachePolicy: .any,
            willReturn: .just(ListStatementsQuery.Data.init(listStatements: [statement])))
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.loadMonthlyStatements()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        // Then
        XCTAssertTrue(statementState.value.count == 1)
        let saved = statementState.value[0]
        XCTAssertEqual(saved.id, statement.fragments.statementFragment.statementId)
        XCTAssertEqual(saved.startDate, DateFormatter.simple.date(from: statement.fragments.statementFragment.periodStart))
        XCTAssertEqual(saved.endDate, DateFormatter.simple.date(from: statement.fragments.statementFragment.periodEnd))
    }

    func testLoadStatements_failed() {
        // Given
        let statementState = container.resolve(ReadOnly<[MonthlyStatement]>.self)
        let response = Fail<ListStatementsQuery.Data, Error>(error: TestError.simple)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<ListStatementsQuery>.any,
            cachePolicy: .any,
            willReturn: response)
        )

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.loadMonthlyStatements()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failed.")
                case .failure:
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)

        // Then
        XCTAssertTrue(statementState.value.count == 0)
    }

    func testGetIndividual_success() {
        // Given
        let individual = IndividualFragment(
            legalName: .init(firstName: "FirstName", lastName: "LastName"),
            birthData: .init(countryOfBirth: "Hungary",
                             placeOfBirth: "Budapest",
                             dateOfBirth: "1976-10-06",
                             motherName: "Some mothername"),
            legalAddress: .init(city: "Budapest",
                                country: "Hungary",
                                houseNumber: "101",
                                postCode: "1111",
                                streetName: "sesame"),
            identityCardDocument: .init(serial: "12345", type: .identityCard, validUntil: "2030-01-01"),
            mainEmail: .init(address: "test@email.com"),
            mobilePhone: .init(fullPhoneNumber: "+36201243254"))

        let response = try! GetIndividualQuery.Data(getIndividual: .init(jsonObject: individual.jsonObject))
        Given(apiMock, .publisher(
            for: Parameter<GetIndividualQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
               willReturn: .just(response))
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 5
        expectation.assertForOverFulfill = true

        // WHen
        var individualResults = [Individual?]()
        var userResults = [User?]()
        individualState.publisher
            .sink { (individual: Individual?) in
                individualResults.append(individual)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        userState.publisher
            .sink(receiveValue: { (user: User?) in
                userResults.append(user)
                expectation.fulfill()
            })
            .store(in: &disposeBag)

        sut.loadIndividual()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be success.")
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<GetIndividualQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertTrue(individualResults[0] == nil)
        XCTAssertNotNil(individualResults[1])
        XCTAssertEqual(individualResults.count, 2)
        XCTAssertEqual(userResults.count, 2)
        XCTAssertNotNil(userResults[1])

        let mapped = individualResults[1]
        XCTAssertEqual(mapped?.birthData?.place, individual.birthData?.placeOfBirth)
        XCTAssertEqual(mapped?.birthData?.motherName, individual.birthData?.motherName)
        XCTAssertEqual(mapped?.birthData?.date, DateFormatter.simple.date(optional: individual.birthData?.dateOfBirth))
        XCTAssertEqual(mapped?.legalName?.firstName, individual.legalName?.fragments.nameFragment.firstName)
        XCTAssertEqual(mapped?.legalName?.lastName, individual.legalName?.fragments.nameFragment.lastName)
        XCTAssertNil(mapped?.birthName)
        XCTAssertEqual(mapped?.legalAddress?.country, individual.legalAddress?.fragments.addressFragment.country)
        XCTAssertEqual(mapped?.legalAddress?.city, individual.legalAddress?.fragments.addressFragment.city)
        XCTAssertEqual(mapped?.legalAddress?.postCode, individual.legalAddress?.fragments.addressFragment.postCode)
        XCTAssertEqual(mapped?.legalAddress?.streetName, individual.legalAddress?.fragments.addressFragment.streetName)
        XCTAssertEqual(mapped?.legalAddress?.houseNumber, individual.legalAddress?.fragments.addressFragment.houseNumber)
        XCTAssertNil(mapped?.correspondenceAddress)
        XCTAssertEqual(mapped?.email.address, individual.mainEmail.fragments.emailFragment.address)
        XCTAssertEqual(mapped?.phoneNumber, individual.mobilePhone.fragments.phoneFragment.fullPhoneNumber)
        XCTAssertEqual(mapped?.identityCard?.serial, individual.identityCardDocument?.fragments.documentFragment.serial)
        XCTAssertEqual(
            mapped?.identityCard?.validUntil,
            DateFormatter.simple.date(optional: individual.identityCardDocument?.fragments.documentFragment.validUntil)
        )
        XCTAssertNil(mapped?.addressCard)
    }

    func testGetIndividual_failure() {
        // Given
        let failure: AnyPublisher<GetIndividualQuery.Data, Error> = Fail<GetIndividualQuery.Data, Error>(
            outputType: GetIndividualQuery.Data.self, failure: TestError.simple
        ).eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetIndividualQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: failure)
        )
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        expectation.assertForOverFulfill = true

        // WHen
        var testResults = [Individual?]()
        individualState.publisher
            .sink { (individual: Individual?) in
                testResults.append(individual)
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        sut.loadIndividual()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failure.")
                case .failure:
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)


        wait(for: [expectation], timeout: 4)

        // Then
        Verify(apiMock, 1, .publisher(
            for: Parameter<GetIndividualQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any)
        )
        XCTAssertTrue(testResults[0] == nil)
        XCTAssertEqual(testResults.count, 1)
    }

    func testCheckPin_success() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]

        Given(apiMock, .publisher(
            for: Parameter<CheckTokenV2Query>.any,
            cachePolicy: .any,
            willReturn: .just(CheckTokenV2Query.Data.init(checkTokenV2: .init(status: .ok))))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verify(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Unexpected failure: \(error)")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<CheckTokenV2Query>.any, cachePolicy: .any))
    }

    func testCheckPin_error_invalid_pin() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]

        Given(apiMock, .publisher(
            for: Parameter<CheckTokenV2Query>.any,
            cachePolicy: .any,
            willReturn: .error(graphQL: .invalidPin))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verify(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    XCTFail("Event should be failed!")
                case .failure(let error):
                    if case .action(let actionError) = error, case .invalidPin(remainingAttempts: let remaining) = actionError {
                        XCTAssertEqual(remaining, 4)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<CheckTokenV2Query>.any, cachePolicy: .any))
    }

    func testCheckPin_error_force_logout() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]

        Given(apiMock, .publisher(
            for: Parameter<CheckTokenV2Query>.any,
            cachePolicy: .any,
            willReturn: .error(graphQL: .forceLogout))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verify(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    XCTFail("Event should be failed!")
                case .failure(let error):
                    if case .action(let actionError) = error, case .forceLogout = actionError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<CheckTokenV2Query>.any, cachePolicy: .any))
    }

    func testCheckPin_failed_decryption() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]

        Given(apiMock, .publisher(
            for: Parameter<CheckTokenV2Query>.any,
            cachePolicy: .any,
            willReturn: .just(CheckTokenV2Query.Data.init(checkTokenV2: .init(status: .error))))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: .init(encryptedKey: Data(), iv: Data(), salt: Data(), ocraSuite: "", ocraPassword: "", expirationDate: 1)) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.verify(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    XCTFail("Event should be failed!")
                case .failure(let error):
                    if case .unknown(let unknownError) = error,
                        let cryptoError = unknownError as? CryptoOtpGen.Error,
                        case .storedKeyAesDecrypt = cryptoError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 0, .publisher(for: Parameter<CheckTokenV2Query>.any, cachePolicy: .any))
    }

    func testRenewSession_success() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]
        let tokenStore = container.resolve((any TokenStore).self)

        let responseAccessToken = "asdomasdm;asd"
        let responseRefreshToken = "asnfdansflsavas"

        let mockResponse = RenewSessionQuery.Data(renewSession: .init(
            accessToken: responseAccessToken,
            refreshToken: responseRefreshToken)
        )
        Given(apiMock, .publisher(
            for: Parameter<RenewSessionQuery>.any,
            cachePolicy: .any,
            willReturn: .just(mockResponse))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.renewSession(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Unexpected failure: \(error)")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<RenewSessionQuery>.any, cachePolicy: .any))
        XCTAssertEqual(tokenStore.state.value?.accessToken, responseAccessToken)
        XCTAssertEqual(tokenStore.state.value?.refreshToken, responseRefreshToken)
    }

    func testRenewSession_error_invalid_pin() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]

        Given(apiMock, .publisher(
            for: Parameter<RenewSessionQuery>.any,
            cachePolicy: .any,
               willReturn: .error(graphQL: .invalidPin))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.renewSession(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    XCTFail("Event should be failed!")
                case .failure(let error):
                    if case .action(let actionError) = error, case .invalidPin(remainingAttempts: let remaining) = actionError {
                        XCTAssertEqual(remaining, 4)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<RenewSessionQuery>.any, cachePolicy: .any))
    }

    func testRenewSession_error_force_logout() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]

        Given(apiMock, .publisher(
            for: Parameter<RenewSessionQuery>.any,
            cachePolicy: .any,
               willReturn: .error(graphQL: .forceLogout))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.renewSession(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    XCTFail("Event should be failed!")
                case .failure(let error):
                    if case .action(let actionError) = error, case .forceLogout = actionError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 1, .publisher(for: Parameter<RenewSessionQuery>.any, cachePolicy: .any))
    }

    func testRenewSession_failed_decryption() {
        // Given
        let givenPin = [1, 2, 3, 4, 3, 2]
        let responseAccessToken = "asdomasdm;asd"
        let responseRefreshToken = "asnfdansflsavas"

        let mockResponse = RenewSessionQuery.Data(renewSession: .init(
            accessToken: responseAccessToken,
            refreshToken: responseRefreshToken)
        )

        Given(apiMock, .publisher(
            for: Parameter<RenewSessionQuery>.any,
            cachePolicy: .any,
            willReturn: .just(mockResponse))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: .init(encryptedKey: Data(), iv: Data(), salt: Data(), ocraSuite: "", ocraPassword: "", expirationDate: 1)) }

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.renewSession(pin: givenPin)
            .sink { event in
                switch event {
                case .finished:
                    XCTFail("Event should be failed!")
                case .failure(let error):
                    if case .unknown(let unknownError) = error,
                        let cryptoError = unknownError as? CryptoOtpGen.Error,
                        case .storedKeyAesDecrypt = cryptoError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(apiMock, 0, .publisher(for: Parameter<RenewSessionQuery>.any, cachePolicy: .any))
    }

    func testChangeMpin_no_saved_biometry_success() {
        // Given
        let oldPin = [1, 2, 3, 4, 3, 2]
        let newPin = [1, 6, 4, 1, 1, 1]

        Given(apiMock, .publisher(
            for: Parameter<ChangePinV2Query>.any,
            cachePolicy: .any,
            willReturn: .just(ChangePinV2Query.Data.init(changePinV2: .init(status: .ok))))
        )

        Given(biometricAuthStoreMock, .isPinCodeSaved(getter: Just(false).eraseToAnyPublisher()))
        Given(biometricAuthStoreMock, .delete(willReturn: Just(true).setFailureType(to: Error.self).ignoreOutput().eraseToAnyPublisher()))

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }
        authKeyStoreMock.modifyInvocations = 0

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.changeMpin(from: oldPin, to: newPin)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be success!")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertTrue(authKeyStoreMock.modifyInvocations == 1)
        Verify(biometricAuthStoreMock, 1, .isPinCodeSaved)
        Verify(biometricAuthStoreMock, 0, .save(pinCode: .any))
        Verify(biometricAuthStoreMock, 1, .delete())
        Verify(apiMock, 1, .publisher(for: Parameter<ChangePinV2Query>.any, cachePolicy: .any))
    }

    func testChangeMpin_with_saved_biometry_success() {
        // Given
        let oldPin: PinCode = [1, 2, 3, 4, 3, 2]
        let newPin: PinCode = [1, 6, 4, 1, 1, 1]

        Given(apiMock, .publisher(
            for: Parameter<ChangePinV2Query>.any,
            cachePolicy: .any,
            willReturn: .just(ChangePinV2Query.Data.init(changePinV2: .init(status: .ok))))
        )

        Given(biometricAuthStoreMock, .isPinCodeSaved(getter: Just(true).eraseToAnyPublisher()))

        Given(biometricAuthStoreMock, .save(pinCode: .any,
            willReturn: Just(()).ignoreOutput().setFailureType(to: Error.self).eraseToAnyPublisher())
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }
        authKeyStoreMock.modifyInvocations = 0

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.changeMpin(from: oldPin, to: newPin)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be success!")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertTrue(authKeyStoreMock.modifyInvocations == 1)
        Verify(biometricAuthStoreMock, 1, .isPinCodeSaved)
        Verify(biometricAuthStoreMock, 1, .save(pinCode: .value(newPin)))
        Verify(apiMock, 1, .publisher(for: Parameter<ChangePinV2Query>.any, cachePolicy: .any))
    }

    func testChangeMpin_backend_verification_failed() {
        // Given
        let oldPin: PinCode = [1, 2, 3, 4, 3, 2]
        let newPin: PinCode = [1, 6, 4, 1, 1, 1]

        Given(apiMock, .publisher(
            for: Parameter<ChangePinV2Query>.any,
            cachePolicy: .any,
            willReturn: .just(ChangePinV2Query.Data.init(changePinV2: .init(status: .error))))
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }
        authKeyStoreMock.modifyInvocations = 0

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.changeMpin(from: oldPin, to: newPin)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Result should be failed!")
                case .failure(let error):
                    if case .action(let actionError) = error, case .pinChangeFailed = actionError {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertTrue(authKeyStoreMock.modifyInvocations == 0)
        Verify(biometricAuthStoreMock, 0, .isPinCodeSaved)
        Verify(biometricAuthStoreMock, 0, .save(pinCode: .value(newPin)))
        Verify(apiMock, 1, .publisher(for: Parameter<ChangePinV2Query>.any, cachePolicy: .any))
    }

    func testChangeMpin_backend_verification_success_but_saving_pin_with_biometry_fails() {
        // Given
        let oldPin: PinCode = [1, 2, 3, 4, 3, 2]
        let newPin: PinCode = [1, 6, 4, 1, 1, 1]

        Given(apiMock, .publisher(
            for: Parameter<ChangePinV2Query>.any,
            cachePolicy: .any,
            willReturn: .just(ChangePinV2Query.Data.init(changePinV2: .init(status: .ok))))
        )

        Given(biometricAuthStoreMock, .isPinCodeSaved(getter: Just(true).eraseToAnyPublisher()))

        Given(biometricAuthStoreMock, .save(pinCode: .any,
            willReturn: Fail<Never, Error>.init(error: TestError.simple).eraseToAnyPublisher())
        )

        Given(biometricAuthStoreMock, .delete(
            willReturn: Just(true).setFailureType(to: Error.self).ignoreOutput().eraseToAnyPublisher())
        )

        authKeyStoreMock.modify { $0 = .init(id: "", keyFile: CryptoMock.validKeyFile()) }
        authKeyStoreMock.modifyInvocations = 0

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        // When
        sut.changeMpin(from: oldPin, to: newPin)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Result should be success!")
                }
            }
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertTrue(authKeyStoreMock.modifyInvocations == 1)
        Verify(biometricAuthStoreMock, 1, .isPinCodeSaved)
        Verify(biometricAuthStoreMock, 1, .save(pinCode: .value(newPin)))
        Verify(apiMock, 1, .publisher(for: Parameter<ChangePinV2Query>.any, cachePolicy: .any))
    }
}

private class MemoryAuthStore: AuthenticationKeyStore {
    var state: ReadOnly<AuthenticationKey?> {
        .init(stateSubject: subject)
    }
    var modifyInvocations = 0
    let subject = CurrentValueSubject<AuthenticationKey?, Never>(nil)

    func modify(_ transform: @escaping (inout AuthenticationKey?) -> Void) {
        modifyInvocations += 1
        var copy = subject.value
        transform(&copy)
        subject.send(copy)
    }
}

private extension GraphQLError {
    static var invalidPin: GraphQLError {
        .from(string:
            """
            {
                "message": "Unauthorized",
                "locations": [
                    {
                        "line": 2,
                        "column": 3
                    }
                ],
                "path": [
                    "login"
                ],
                "extensions": {
                    "id": "d52f7f1e-2773-42cc-96b9-53310f8bcbe0",
                    "status": "WRONG_OTP",
                    "statusCode": 403,
                    "message": "Unauthorized",
                    "errors": [],
                    "data": {"remainingAttempts":4}
                }
            }
            """
        )
    }

    static var forceLogout: GraphQLError {
        .from(string:
            """
            {
                 "message":"Please reactivate the device.",
                 "locations":[
                    {
                       "line":2,
                       "column":3
                    }
                 ],
                 "path":[
                    "login"
                 ],
                 "extensions": {
                    "id": "556cb1e1-31ba-4aab-95ab-0451c268c16e",
                    "status": "FORCE_LOGOUT",
                    "statusCode": 423,
                    "message": "Please reactivate the device.",
                    "errors": [],
                }
            }
            """
        )
    }
}
