//
//  ResetAction.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 16..
//

import BankAPI
import Combine
import CoreData
import KeychainAccess
import Resolver

protocol ResetAction {
    func reset() -> AnyPublisher<Never, AnyActionError>
}

class ResetActionImpl: ResetAction {
    @Injected(container: .root) private var persistentContainer: NSPersistentContainer
    @Injected(container: .root) private var tokenStore: any TokenStore
    @Injected(container: .root) private var authKeyStore: any AuthenticationKeyStore
    @Injected(container: .root) private var biometricAuthStore: any BiometricAuthStore
    @Injected(container: .root) private var deviceInfo: DeviceInformation
    @Injected private var api: APIProtocol
    @Injected private var subscriptionStore: any PushSubscriptionStore

    func reset() -> AnyPublisher<Never, AnyActionError> {
        Just(())
            .setFailureType(to: Error.self)
            .flatMap { [api, deviceInfo] in
                api.publisher(for: ResetDeviceMutation(deviceId: deviceInfo.id))
            }
            .tryMap { _ -> Void in
                return ()
            }
            .retry(times: 5) { _ in
                return true
            }
            .handleEvents(receiveOutput: { [tokenStore, persistentContainer, authKeyStore, subscriptionStore] _ -> Void in
                tokenStore.modify { $0 = nil }
                authKeyStore.modify { $0 = nil }
                persistentContainer.clearAllData()
                // Make sure to clear push token subscription after auth state is reset
                subscriptionStore.modify { $0 = nil }
            })
            .flatMap(biometricAuthStore.delete)
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }
}
