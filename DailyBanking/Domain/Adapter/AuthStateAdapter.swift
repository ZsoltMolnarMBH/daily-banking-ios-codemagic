//
//  AuthStore.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Combine
import Foundation
import Resolver

enum AuthState {
    case initial
    case activated
    case authenticated
}

struct AuthKey {
    let id: String
    let keyFile: KeyFile
}

struct AuthStateAdapter {
    @Injected(container: .root) private var keyFile: ReadOnly<AuthenticationKey?>
    @Injected(container: .root) private var token: ReadOnly<Token?>

    var state: ReadOnly<AuthState> {
        let publisher = Publishers.CombineLatest(
            keyFile.publisher,
            token.publisher
        )
        .map(convert)
        .dropFirst()
        .debounce(for: 0.1, scheduler: DispatchQueue.main)
        .removeDuplicates()

        return ReadOnly(
            value: convert(keyFile: keyFile.value, token: token.value),
            publisher: publisher.eraseToAnyPublisher()
        )
    }

    private func convert(keyFile: AuthenticationKey?, token: Token?) -> AuthState {
        if keyFile != nil && token != nil {
            return .authenticated
        } else if keyFile != nil && token == nil {
            return .activated
        } else {
            return .initial
        }
    }
}
