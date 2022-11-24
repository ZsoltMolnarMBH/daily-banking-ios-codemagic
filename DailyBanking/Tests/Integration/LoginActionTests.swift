//
//  LoginActionTests.swift
//  DailyBankingTests
//
//  Created by Molnár Zsolt on 2021. 11. 18..
//

import XCTest
import Combine
import Resolver
import SwiftyMocky
import BankAPI
import Apollo

@testable import DailyBanking

class LoginActionTests: BaseTestCase {
}

private class MemoryAuthStore: MemoryStore<AuthenticationKey?>, AuthenticationKeyStore {
    init() {
        super.init(state: nil)
    }
}

private class MemoryOnboardingStateStore: MemoryStore<OnboardingState>, OnboardingStateStore {
    init() {
        super.init(state: .init(isBiometricAuthPromotionRequired: false, isRegistrationSuccessScreenRequired: false))
    }
}
