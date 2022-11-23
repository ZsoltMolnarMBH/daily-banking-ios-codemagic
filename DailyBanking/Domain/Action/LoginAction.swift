//
//  LoginAction.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 25..
//

import Apollo
import BankAPI
import Combine
import CryptoSwift
import Resolver
import Foundation

enum LoginError: Error {
    case keyfileMissing
    case invalidPin(remainingAttempts: Int)
    case temporaryBlocked(blockedTime: Int)
    case deviceActivationRequired
}

protocol LoginAction: AutoMockable {
    func login(pin: PinCode) -> AnyPublisher<Never, ActionError<LoginError>>
}

class LoginActionImpl: LoginAction {

    @Injected private var tokenStore: any TokenStore
    @Injected private var authKeyStore: any AuthenticationKeyStore
    @Injected private var api: APIProtocol
    @Injected private var otpGenerator: OtpGenerator
    @Injected private var tokenMapper: Mapper<TokenFragment, Token>
    @Injected private var errorMapper: Mapper<[GraphQLError], LoginError?>
    @Injected private var device: DeviceInformation
    @Injected private var onboardingState: ReadOnly<OnboardingState>
    @Injected private var pinStore: any TemporaryPinStore

    private var deviceId: String {
        device.id.sha512()
    }

    func login(pin: PinCode) -> AnyPublisher<Never, ActionError<LoginError>> {
        guard let authKey = authKeyStore.state.value else {
            return Fail(error: .action(LoginError.keyfileMissing)).eraseToAnyPublisher()
        }
        return Just((authKey, pin, deviceId))
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { [otpGenerator] authKey, pin, deviceId -> String in
                try otpGenerator.createOtp(
                    keyFile: authKey.keyFile,
                    mpin: pin.stringValue,
                    deviceId: deviceId
                )
            }
            .map { [deviceId] (otp: String) -> LoginV2Query in
                LoginV2Query(otp: otp, phoneNumber: authKey.id, deviceId: deviceId)
            }
            .flatMap { [api] query -> AnyPublisher<LoginV2Query.Data, Error> in
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
                try tokenMapper.map(result.loginV2.fragments.tokenFragment)
            })
            .map({ [tokenStore, onboardingState, pinStore] token in
                if onboardingState.value.isBiometricAuthPromotionRequired {
                    pinStore.modify {
                        $0 = pin
                    }
                }
                tokenStore.modify {
                    $0 = token
                }
            })
            .sendCrashlyticsError()
            .ignoreOutput()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .mapActionError(to: LoginError.self)
    }
}
