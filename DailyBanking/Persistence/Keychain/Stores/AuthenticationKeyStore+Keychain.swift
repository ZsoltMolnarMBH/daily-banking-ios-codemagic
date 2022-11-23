//
//  AuthenticationKeyStore+Keychain.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import Foundation

class KeychainAuthenticationKeyStore: KeychainStore<AuthenticationKey>, AuthenticationKeyStore {
    init() {
        super.init(key: "authkey")
    }
}
