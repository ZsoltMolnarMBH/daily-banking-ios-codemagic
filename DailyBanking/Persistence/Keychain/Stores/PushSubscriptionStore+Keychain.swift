//
//  PushSubscriptionStore+Keychain.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 09. 15..
//

import Foundation

class KeychainPushSubscriptionStore: KeychainStore<String>, PushSubscriptionStore {
    init() {
        super.init(key: "pushToken")
    }
}
