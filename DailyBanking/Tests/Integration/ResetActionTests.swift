//
//  ResetActionTests.swift
//  DailyBankingTests
//
//  Created by ALi on 2022. 06. 21..
//

import XCTest
import Combine
import BankAPI
import KeychainAccess
import SwiftyMocky
import Resolver
@testable import DailyBanking
import CoreData

class ResetActionTests: BaseTestCase {
    private let apiMock = APIProtocolMock()
    private var sut: ResetActionImpl!
    private var tokenStoreMock: (any TokenStore)!
    private var authKeyStoreMock: (any AuthenticationKeyStore)!
    private var biometricAuthStore: BiometricAuthStoreMock!
    private var disposeBag: Set<AnyCancellable>!

    override func setUp() {
        container = makeMainContainer()

        container.register { self.apiMock as APIProtocol }

        tokenStoreMock = MemoryTokenStore()
        Resolver.root.register{ self.tokenStoreMock as any TokenStore }

        authKeyStoreMock = MemoryAuthenticationKeyStore()
        Resolver.root.register { self.authKeyStoreMock as any AuthenticationKeyStore }

        biometricAuthStore = .init()
        Resolver.root.register { self.biometricAuthStore as BiometricAuthStore }

        disposeBag = Set<AnyCancellable>()

        container.useContext {
            sut = ResetActionImpl()
        }
    }

    override func tearDown() {
        sut = nil
        tokenStoreMock = nil
        authKeyStoreMock = nil
        biometricAuthStore = nil
        disposeBag = nil
    }

    func testResetWorks() {

        // --- GIVEN
        Given(
            apiMock,
            .publisher(
                for: Parameter<ResetDeviceMutation>.any,
                willReturn: .just(.success()))
        )

        tokenStoreMock.modify {
            $0 = .init(accessToken: "accessToken", refreshToken: "refreshToken")
        }
        authKeyStoreMock.modify {
            $0 = .init(id: "5", keyFile: .init(encryptedKey: Data(), iv: Data(), salt: Data(), ocraSuite: "", ocraPassword: "", expirationDate: 5))
        }
        Given(biometricAuthStore, .delete(willReturn: Just(()).setFailureType(to: Error.self).ignoreOutput().eraseToAnyPublisher()))

        // --- WHEN

        let expectation = XCTestExpectation()

        sut.reset().sink { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure(_):
                Failure("Operation should be finished!")
            }
        }.store(in: &disposeBag)

        // --- THEN

        wait(for: [expectation], timeout: 4)

        Verify(biometricAuthStore, 1, .delete())
        XCTAssertNil(tokenStoreMock.state.value)
        XCTAssertNil(authKeyStoreMock.state.value)
        Verify(apiMock, 1, .publisher(for: Parameter<ResetDeviceMutation>.any))
    }
}

private class MemoryAuthenticationKeyStore: MemoryStore<AuthenticationKey?>, AuthenticationKeyStore {
    init() {
        super.init(state: nil)
    }
}

extension ResetDeviceMutation.Data {
    static func success() -> ResetDeviceMutation.Data {
        return ResetDeviceMutation.Data(resetDevice: ResetDevice(status: .ok))
    }
}
