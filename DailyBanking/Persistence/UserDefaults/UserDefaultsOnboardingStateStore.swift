//
//  UserDefaultsOnboardingStateStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 13..
//

import Combine
import Foundation
import UIKit

class UserDefaultsOnboardingStateStore: OnboardingStateStore {
    var state: ReadOnly<OnboardingState> {
        ReadOnly<OnboardingState>(stateSubject: stateSubject)
    }

    private let stateSubject: CurrentValueSubject<OnboardingState, Never>
    private var lock: NSRecursiveLock = NSRecursiveLock()
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        stateSubject = CurrentValueSubject<OnboardingState, Never>(Self.makeInfo(from: userDefaults))
    }

    func modify(_ transform: @escaping (inout OnboardingState) -> Void) {
        lock.lock(); defer { lock.unlock() }
        var copy = stateSubject.value
        transform(&copy)
        save(info: copy)
        stateSubject.send(copy)
    }

    static let biometricAuthPromotionRequiredKey = "isBiometricAuthPromotionRequired"
    static let registrationSuccessRequiredKey = "isRegistrationSuccessRequiredKey"

    private static func makeInfo(from userDefaults: UserDefaults) -> OnboardingState {
        OnboardingState(
            isBiometricAuthPromotionRequired: userDefaults.bool(forKey: biometricAuthPromotionRequiredKey),
            isRegistrationSuccessScreenRequired: userDefaults.bool(forKey: registrationSuccessRequiredKey)
        )
    }

    private func save(info: OnboardingState) {
        userDefaults.set(info.isBiometricAuthPromotionRequired, forKey: Self.biometricAuthPromotionRequiredKey)
        userDefaults.set(info.isRegistrationSuccessScreenRequired, forKey: Self.registrationSuccessRequiredKey)
    }
}
