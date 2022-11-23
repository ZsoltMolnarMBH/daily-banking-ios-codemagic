//
//  ProfileAction.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 07..
//

import Apollo
import BankAPI
import Combine
import CryptoSwift
import Foundation
import Resolver
import KeychainAccess

protocol UserAction {
    func loadIndividual() -> AnyPublisher<Never, AnyActionError>
    func loadContracts() -> AnyPublisher<Never, AnyActionError>
    func loadMonthlyStatements() -> AnyPublisher<Never, AnyActionError>
    func verify(pin: PinCode) -> AnyPublisher<Never, ActionError<PinVerificationError>>
    func renewSession(pin: PinCode) -> AnyPublisher<Never, ActionError<PinVerificationError>>
    func changeMpin(from oldPin: PinCode, to newPin: PinCode) -> AnyPublisher<Never, ActionError<ChangePinError>>
    func logout() -> AnyPublisher<Never, Never>
}

enum ChangePinError: Error {
    case pinChangeFailed
}

class UserActionImpl: UserAction {
    @Injected private var tokenStore: any TokenStore
    @Injected private var biometricStore: BiometricAuthStore
    @Injected private var authKeyStore: any AuthenticationKeyStore
    @Injected private var contractStore: any UserContractStore
    @Injected private var monthlyStatementsStore: any MonthlyStatementsStore
    @Injected private var api: APIProtocol
    @Injected private var individualStore: any IndividualStore
    @Injected private var userStore: any UserStore
    @Injected private var keychain: Keychain
    @Injected private var otpGenerator: OtpGenerator
    @Injected private var device: DeviceInformation
    @Injected private var individualMapper: Mapper<IndividualFragment, Individual>
    @Injected private var contractListMapper: Mapper<UserContractFragment, UserContract>
    @Injected private var statementMapper: Mapper<StatementFragment, MonthlyStatement>
    @Injected private var userMapper: Mapper<Individual, User?>
    @Injected private var tokenMapper: Mapper<TokenFragment, Token>
    @Injected private var errorMapper: Mapper<[GraphQLError]?, PinVerificationError?>

    private var deviceId: String {
        device.id.sha512()
    }

    func loadIndividual() -> AnyPublisher<Never, AnyActionError> {
        let query = GetIndividualQuery()
        return api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap({ [individualMapper, userMapper] data in
                let individual = try individualMapper.map(data.getIndividual.fragments.individualFragment)
                return (individual: individual, user: try userMapper.map(individual))
            })
            .map({ [individualStore, userStore] (individual: Individual, user: User?) in
                individualStore.modify {
                    $0 = individual
                }
                if let user = user {
                    userStore.modify {
                        $0 = user
                    }
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func loadContracts() -> AnyPublisher<Never, AnyActionError> {
        let query = ListContractsQuery()
        return api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap { [contractListMapper] data -> [UserContract] in
                let list: [UserContractFragment] = data.listContracts.map { $0.fragments.userContractFragment }
                return try contractListMapper.map(list)
            }
            .map { [contractStore] contracts in
                contractStore.modify {
                    $0 = contracts
                }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func loadMonthlyStatements() -> AnyPublisher<Never, AnyActionError> {
        let query = ListStatementsQuery()
        return api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            .map { [statementMapper] data -> [MonthlyStatement] in
                let dto = data.listStatements.map { $0.fragments.statementFragment }
                return statementMapper.compactMap(dto)
            }
            .map { [monthlyStatementsStore] statements in
                monthlyStatementsStore.modify {
                    $0 = statements
                }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func verify(pin: PinCode) -> AnyPublisher<Never, ActionError<PinVerificationError>> {
        guard let keyfile = authKeyStore.state.value?.keyFile else { fatalError("Keyfile is missing!") }
        return Just(keyfile)
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { [otpGenerator, deviceId] keyFile -> String in
                try otpGenerator.createOtp(
                    keyFile: keyFile,
                    mpin: pin.stringValue,
                    deviceId: deviceId
                )
            }
            .flatMap { [api] in
                api.publisher(for: CheckTokenV2Query(otp: $0), cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .mapError { [errorMapper] error -> Error in
                if case .graphQLError(errors: let errors) = error as? BankAPI.Error {
                    if let error = try? errorMapper.map(errors) {
                        return error
                    }
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .sendCrashlyticsError()
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: PinVerificationError.self)
    }

    func renewSession(pin: PinCode) -> AnyPublisher<Never, ActionError<PinVerificationError>> {
        guard let authKey = authKeyStore.state.value else { fatalError("Keyfile is missing!") }
        return Just(authKey)
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { [otpGenerator, deviceId] authKey -> String in
                try otpGenerator.createOtp(
                    keyFile: authKey.keyFile,
                    mpin: pin.stringValue,
                    deviceId: deviceId
                )
            }
            .map { [deviceId] otp -> RenewSessionQuery in
                RenewSessionQuery(otp: otp, phoneNumber: authKey.id, deviceId: deviceId)
            }
            .flatMap { [api] query -> AnyPublisher<RenewSessionQuery.Data, Error> in
                api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .mapError { [errorMapper] error -> Error in
                if case .graphQLError(errors: let errors) = error as? BankAPI.Error,
                   let error = try? errorMapper.map(errors) {
                    return error
                }
                return error
            }
            .tryMap({ [tokenMapper] result -> Token in
                try tokenMapper.map(result.renewSession.fragments.tokenFragment)
            })
            .map({ [tokenStore] token in
                tokenStore.modify {
                    $0 = token
                }
            })
            .sendCrashlyticsError()
            .ignoreOutput()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .mapActionError(to: PinVerificationError.self)
    }

    func changeMpin(from oldPin: PinCode, to newPin: PinCode) -> AnyPublisher<Never, ActionError<ChangePinError>> {
        guard let keyfile = authKeyStore.state.value?.keyFile,
              let id = authKeyStore.state.value?.id else { fatalError("Keyfile or phoneNumber is missing!") }
        return Just(keyfile)
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap({ [otpGenerator, deviceId] keyFile -> (otp: String, keyfile: KeyFile) in
                let newKeyFile = try otpGenerator.createNewKeyFile(
                    oldKeyFile: keyFile,
                    oldMpin: oldPin.stringValue,
                    newMpin: newPin.stringValue,
                    deviceId: deviceId
                )
                let otp = try otpGenerator.createOtp(keyFile: newKeyFile, mpin: newPin.stringValue, deviceId: deviceId)
                return (otp, newKeyFile)
            })
            .flatMap({ [api] (otp, newKeyfile) in
                Publishers.Zip(
                    api.publisher(for: ChangePinV2Query(otp: otp), cachePolicy: .fetchIgnoringCacheCompletely),
                    Just(newKeyfile).setFailureType(to: Error.self)
                )
            })
            .tryMap { [authKeyStore] (response, newKeyfile) -> Void in
                if response.changePinV2.status != .ok {
                    throw ChangePinError.pinChangeFailed
                }
                authKeyStore.modify {
                    $0 = .init(id: id, keyFile: newKeyfile)
                }
            }
            .flatMap { [biometricStore] _ in
                biometricStore.isPinCodeSaved.first()
            }
            .flatMap { [biometricStore] isSaved -> AnyPublisher<Never, Error> in
                guard isSaved else {
                    // If the user not using the biometry auth, we delete the stored one
                    return biometricStore.delete()
                }
                return biometricStore
                    .save(pinCode: newPin)
                    .catch { [biometricStore] _ in
                        // we couldn't save the pin with biometry, probably deviceOwnerEvaluation failed..
                        return biometricStore.delete()
                    }
                    .eraseToAnyPublisher()
            }
            .sendCrashlyticsError()
            .receive(on: DispatchQueue.main)
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: ChangePinError.self)
    }

    func logout() -> AnyPublisher<Never, Never> {
        Just(tokenStore)
            .handleEvents(receiveOutput: { tokenStore in
                tokenStore.modify { $0 = nil }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
}
