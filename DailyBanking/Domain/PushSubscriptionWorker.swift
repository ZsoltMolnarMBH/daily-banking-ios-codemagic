//
//  PushSubscriptionWorker.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 08. 25..
//

import Resolver
import Combine
import BankAPI

protocol PushSubscriptionStore: Store where State == String? { }

protocol PushSubscriptionConfig {
    var pushSubscriptionRetryDelay: Double { get }
}

class PushSubscriptionWorker {
    @Injected private var authState: ReadOnly<AuthState>
    @Injected(name: .app.pushToken) private var token: ReadOnly<String?>
    @Injected private var subscriptionStore: any PushSubscriptionStore
    @Injected private var api: APIProtocol
    @Injected private var config: PushSubscriptionConfig
    private var disposeBag = Set<AnyCancellable>()

    private let queue = DispatchQueue(label: "PushSubscriptionWorker")

    enum SubscribeInstruction: Equatable {
        case subscribe(String)
        case unsubscribe(String)
    }

    init() {
        let trigger = makeInstruction()
            .removeDuplicates()
            .compactMap({ $0 })
            .receive(on: queue)
            .eraseToAnyPublisher()

        let response = trigger
            .map { instruction -> String? in
                switch instruction {
                case .subscribe(let token):
                    return token
                case .unsubscribe:
                    return nil
                }
            }
            .flatMap { [api] token in
                api.publisher(for: SetPushTokenMutation(token: token))
            }
            .tryMap { response -> Void in
                switch response.setPushToken.status {
                case .ok, .__unknown:
                    return ()
                case .error:
                    // 🤷🏻‍♂️ We don't actually know what cases does the server respond with this
                    throw ResponseStatusError.statusFailed
                }
            }
            .retry(times: Int.max, delay: config.pushSubscriptionRetryDelay) { _ in
                return true // 🥺 Keep trying until we succeed
            }
            .catch { _ in
                Just<Void>(()) // 👆 Will not happen due to always retrying
            }
        Publishers.Zip(response, trigger)
            .sink { [subscriptionStore] (_, instruction) in
                switch instruction {
                case .subscribe(let token):
                    subscriptionStore.modify { $0 = token }
                case .unsubscribe:
                    subscriptionStore.modify { $0 = nil }
                }
            }
            .store(in: &disposeBag)
    }

    func makeInstruction() -> AnyPublisher<SubscribeInstruction?, Never> {
        return Publishers.CombineLatest3(
            token.publisher,
            subscriptionStore.state.publisher,
            authState.publisher)
            .map { (currentToken, subscribedToken, authState) -> SubscribeInstruction? in
                switch authState {
                case .initial, .activated:
                    // Device not activated or was signed out
                    // Signout process should unsubscribe
                    return .none
                case .authenticated:
                    guard let currentToken = currentToken, !currentToken.isEmpty else {
                        // Push token permission not given or revoked, nothing to do
                        return .none
                    }

                    if let subscribedToken = subscribedToken, !subscribedToken.isEmpty {
                        // We have subscribed a token already
                        if currentToken == subscribedToken {
                            // Current and Subscribed tokens are valid and matching, nothing to do
                            return .none
                        } else {
                            // Current and Subscribed tokens are valid, but not matching (current token was refreshed)
                            return .unsubscribe(subscribedToken)
                        }
                    } else {
                        // We have no subscribed token
                        return .subscribe(currentToken)
                    }
                }
            }
            .eraseToAnyPublisher()
    }
}
