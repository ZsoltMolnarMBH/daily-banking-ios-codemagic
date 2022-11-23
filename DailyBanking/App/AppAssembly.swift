//
//  AppAssembly.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 15..
//

import Apollo
import Combine
import CoreData
import Resolver
import BankAPI
import DesignKit
import KeychainAccess
import LocalAuthentication
import Confy

extension Resolver.Name {
    static let app = App()
    struct App { }
}

extension Resolver.Name.App {
    var pushToken: Resolver.Name { ".app.pushToken" }
}

class AppAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            WindowCover(content: { FullScreenCoverView() })
        }.implements(FullScreenCover.self)

        container.registerInContext {
            SecondLevelAuthentication()
        }.scope(.application)

        container.registerInContext {
            UIApplication.shared as? DailyBankingApplication
        }
        .implements(UserTouchActivityProvider.self)

        container.registerInContext(DeviceInformation.self) {
            DeviceInformationProvider().information
        }
        .scope(.application)

        container.registerInContext(AppInformation.self) {
            AppInformationProvider().information
        }
        .scope(.application)

        container.registerInContext {
            AppConfig()
        }
        .scope(.application)

        container.registerInContext {
            EnvironmentConfig()
        }
        .scope(.application)

        container.registerInContext { container in
            container.resolve(EnvironmentConfig.self).currentEnvironment
        }

        container.registerInContext(NSPersistentContainer.self) {
            let persistentContainer = NSPersistentContainer(name: "app-daily-banking")
            persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return persistentContainer
        }
        .scope(container.cache)

        container.registerInContext { AppAnalytics() }
        .implements(DesignKit.AnalyticsInterface.self)
        .implements(ViewAnalyticsInterface.self)
        .scope(container.cache)

        container.registerInContext(ApolloClient.self) { container in
            let env: RemoteEnvironment = container.resolve()
            let cache = InMemoryNormalizedCache()
            let store = ApolloStore(cache: cache)
            let appConfig = container.resolve(AppConfig.self)
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = appConfig.general.networkTimeout
            let client = URLSessionClient(sessionConfiguration: config)
            let provider = NetworkInterceptorProvider(store: store, client: client)

            let requestChainTransport = RequestChainNetworkTransport(
                interceptorProvider: provider,
                endpointURL: env.graphQLEndpoint
            )

            return ApolloClient(networkTransport: requestChainTransport,
                                store: store)
        }
        .implements(ApolloClientProtocol.self)
        .scope(.unique)

        container.registerInContext {
            RefreshTokenActionImpl()
        }
        .implements(RefreshTokenAction.self)
        .scope(container.cache)

        container.registerInContext(BankAPI.self) { container in
            BankAPI(apollo: container.resolve())
        }
        .implements(APIProtocol.self)
        .scope(container.cache)

        container.registerInContext { container in
            CoreDataUserStore(persistentContainer: container.resolve())
        }
        .implements((any UserStore).self)
        .scope(container.cache)

        container.registerInContext(MemoryTokenStore.self) {
            return MemoryTokenStore()
        }
        .implements((any TokenStore).self)
        .scope(container.cache)

        container.registerInContext {
            Keychain(service: Bundle.main.bundleIdentifier ?? "")
        }.scope(container.cache)

        container.registerInContext {
            KeychainAuthenticationKeyStore()
        }
        .implements((any AuthenticationKeyStore).self)
        .scope(container.cache)

        container.registerInContext {
            UserDefaultsOnboardingStateStore()
        }
        .implements((any OnboardingStateStore).self)
        .scope(container.cache)

        container.registerInContext {
            MemoryTemporaryPinStore()
        }
        .implements((any TemporaryPinStore).self)
        .scope(container.cache)

        container.registerInContext {
            AuthStateAdapter()
        }

        container.registerInContext(ReadOnly<PinCode?>.self) { container in
            let store = container.resolve((any TemporaryPinStore).self)
            return store.state
        }

        container.registerInContext(ReadOnly<OnboardingState>.self) { container in
            let store = container.resolve((any OnboardingStateStore).self)
            return store.state
        }

        container.registerInContext(ReadOnly<Token?>.self) { container in
            let store = container.resolve((any TokenStore).self)
            return store.state
        }

        container.registerInContext(ReadOnly<User?>.self) { container in
            let store = container.resolve((any UserStore).self)
            return store.state
        }

        container.registerInContext(ReadOnly<AuthenticationKey?>.self) { container in
            let store = container.resolve((any AuthenticationKeyStore).self)
            return store.state
        }

        container.registerInContext(ReadOnly<AuthState>.self) { container in
            let adapter = container.resolve(AuthStateAdapter.self)
            return adapter.state
        }

        container.registerInContext(Mapper<UserEntity, User>.self) {
            UserDataToDomainMapper()
        }

//        container.registerInContext {
//            CryptoBankCard()
//        }
//        .implements(BankCardCipher.self)
//
//        container.registerInContext {
//            CryptoOtpGen()
//        }
//        .implements(OtpGenerator.self)

        container.registerInContext {
            #if targetEnvironment(simulator)
                KeychainBiometricAuthStore()
            #else
                SecuredBiometricAuthStore()
            #endif
        }
        .implements(BiometricAuthStore.self)
        .scope(container.cache)

        container.registerInContext {
            ContactsScreenViewModel()
        }

        container.registerInContext {
            PinInfoScreenViewModel()
        }

        container.registerInContext(PinInfoScreen<PinInfoScreenViewModel>.self) { container in
            .init(viewModel: container.resolve())
        }

        container.registerInContext {
            ResetActionImpl()
        }
        .implements(ResetAction.self)

        container.registerInContext(Mapper<TokenFragment, Token>.self) {
            TokenMapper()
        }

        container.registerInContext(Mapper<[GraphQLError]?, PinVerificationError?>.self) {
            PinVerificationErrorMapper()
        }

        container.registerInContext(Mapper<MoneyFragment, Money>.self) {
            MoneyMapper()
        }

        container.registerInContext(EmailClientManaging.self) { _ in
            EmailClientManager()
        }.scope(container.cache)

        container.registerInContext {
            ForceUpdateSignaling()
        }
        .implements(ForceUpdateSignalReceiver.self)
        .implements(ForceUpdateSignalBroadcaster.self)
        .scope(.application)

        container.registerInContext {
            ReachabilityMonitor()
        }.scope(container.cache)

        container.registerInContext(name: .app.pushToken) {
            PushTokenAdapter().token
        }
        .scope(container.cache)

        container.registerInContext {
            KeychainPushSubscriptionStore()
        }
        .implements((any PushSubscriptionStore).self)
        .scope(container.cache)
    }
}
