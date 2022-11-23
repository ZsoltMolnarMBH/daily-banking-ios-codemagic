//
//  BiometricAuthStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 09..
//

import Combine
import Foundation
import KeychainAccess
import Resolver
import LocalAuthentication

protocol BiometricAuthStore: AutoMockable {
    var isPinCodeSaved: AnyPublisher<Bool, Never> { get }

    func save(pinCode: PinCode) -> AnyPublisher<Never, Error>
    func read() -> AnyPublisher<PinCode?, Error>
    func delete() -> AnyPublisher<Never, Error>
}

enum BiometricAuthStoreError: Error {
    case cannotEvaluateOwner
}

class SecuredBiometricAuthStore: BiometricAuthStore {

    @Injected(container: .root) private var keychain: Keychain
    private let pinCodeKey = "pinCode"
    private let pinCodeExistenceKey = "pinCodeExistence"

    private var isSaved = PassthroughSubject<Bool, Never>()
    var isPinCodeSaved: AnyPublisher<Bool, Never> {
        let value: Bool = (try? keychain.contains(pinCodeExistenceKey)) ?? false
        return isSaved
            .prepend(value)
            .eraseToAnyPublisher()
    }

    func save(pinCode: PinCode) -> AnyPublisher<Never, Error> {
        let authContext = LAContext.new
        guard authContext.biometryType != .none else {
            return Fail<Never, Swift.Error>(error: BiometricAuthStoreError.cannotEvaluateOwner)
                .eraseToAnyPublisher()
        }
        let pinString = convert(pinCode: pinCode)

        return authContext.evaluateOwner()
            .tryFilter { isEvaluated in
                if isEvaluated {
                    return true
                }
                throw BiometricAuthStoreError.cannotEvaluateOwner
            }
            .flatMap { [keychain] _ in
                Just(keychain)
            }
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { [pinCodeKey, pinCodeExistenceKey] keychain -> Void in
                try keychain.remove(pinCodeKey)
                try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])
                    .set(pinString, key: pinCodeKey)

                return try keychain.set("pincodeSaved", key: pinCodeExistenceKey)
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [isSaved] _ in
                isSaved.send(true)
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func read() -> AnyPublisher<PinCode?, Swift.Error> {
        Just(keychain)
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { [pinCodeKey] keychain in
                try keychain
                    .authenticationPrompt(LAContext.new.localizedReason)
                    .get(pinCodeKey)
            }
            .map({ [weak self] pinString in
                guard let self = self,
                      let pinString = pinString else { return nil }
                return self.convert(string: pinString)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func delete() -> AnyPublisher<Never, Error> {
        Just(keychain)
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { [pinCodeKey, pinCodeExistenceKey] keychain in
                try keychain.remove(pinCodeKey)
                try keychain.remove(pinCodeExistenceKey)
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [isSaved] _ in
                isSaved.send(false)
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    private func convert(pinCode: PinCode) -> String {
        pinCode.map { String($0) }.joined(separator: ",")
    }

    private func convert(string: String) -> PinCode {
        string.split(separator: ",").compactMap { Int($0) }
    }
}

/// This class should be used for simulator builds only!
/// https://developer.apple.com/forums/thread/685773
class KeychainBiometricAuthStore: BiometricAuthStore {

    @Injected(container: .root) private var keychain: Keychain
    private let pinCodeKey = "pinCode"
    private let authContext = LAContext.new

    private var isSaved = PassthroughSubject<Bool, Never>()
    var isPinCodeSaved: AnyPublisher<Bool, Never> {
        let value: Bool = (try? keychain.contains(pinCodeKey)) ?? false
        return isSaved
            .prepend(value)
            .eraseToAnyPublisher()
    }

    init() {
        #if !targetEnvironment(simulator)
            fatalError("This class should be used for simulator builds only!")
        #endif
    }

    func save(pinCode: PinCode) -> AnyPublisher<Never, Error> {
        let pinString = convert(pinCode: pinCode)
        return authContext.evaluateOwner()
            .tryMap { [keychain] isOwner -> Keychain in
                if isOwner {
                    return keychain
                }
                throw BiometricAuthStoreError.cannotEvaluateOwner
            }
            .tryMap { [pinCodeKey] keychain -> Void in
                try keychain.set(pinString, key: pinCodeKey)
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [isSaved] _ in
                isSaved.send(true)
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func read() -> AnyPublisher<PinCode?, Swift.Error> {
        authContext
            .evaluateOwner()
            .tryMap { [keychain] isOwner -> Keychain in
                if isOwner {
                    return keychain
                }
                throw BiometricAuthStoreError.cannotEvaluateOwner
            }
            .tryMap { [pinCodeKey] keychain in
                try keychain.get(pinCodeKey)
            }
            .map({ [weak self] pinString in
                guard let self = self,
                      let pinString = pinString else { return nil }
                return self.convert(string: pinString)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func delete() -> AnyPublisher<Never, Error> {
        Just(keychain)
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { [pinCodeKey] keychain in
                try keychain.remove(pinCodeKey)
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [isSaved] _ in
                isSaved.send(false)
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    private func convert(pinCode: PinCode) -> String {
        pinCode.map { String($0) }.joined(separator: ",")
    }

    private func convert(string: String) -> PinCode {
        string.split(separator: ",").compactMap { Int($0) }
    }
}
