//
//  AppConfig.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 04..
//

import Confy

class AppConfig: ConfigGroup {
    let general = General()
    class General: ConfigGroup, PushSubscriptionConfig {
        @Config({
            #if DEVELOPMENT
            false
            #else
            true
            #endif
        }) var isAnalyticsCollectionEnabled

        @Config({ 0 }) var communicationDelay: Double

        @Config({ 20 }) var networkTimeout: Double

        @Config({
            #if DEVELOPMENT
            true
            #else
            false
            #endif
        }) var bankCardEnabled: Bool

        @Config({ 5 }) var pushSubscriptionRetryDelay: Double
    }

    let session = Session()
    class Session: ConfigGroup, SessionConfig {
        @Config({ 60 }) var backgroundExpirationTime: Double
        @Config({ 240 }) var foregroundInactivityWarningTime: Double
        @Config({ 300 }) var foregroundInactivityExpirationTime: Double
    }

    let newTransfer = NewTransfer()
    class NewTransfer: ConfigGroup, NewTransferConfig {
        @Config({ 10 }) var pollCount
        @Config({ 1.0 }) var pollingInterval: Double
        @Config({ 0.5 }) var feeFetchDebounceTime: Double
        @Config({ true }) var isInlineValidationEnabled
    }

    let accountOpening = AccountOpening()
    class AccountOpening: ConfigGroup, AccountOpeningConfig {
        @Config({ false }) var isKycEnabled: Bool
        @Config({ true }) var skipEmailValidation
    }

    let kyc = Kyc()
    class Kyc: ConfigGroup, KycConfig {
        @Config({ false }) var safeDocumentPreviews: Bool
        @Config({ true }) var autoCloseRoom: Bool
        @Config({ true }) var useFlashOnHologramCheck: Bool
        @Config({ 0.2 }) var selfieCropSize: Double
    }

    let dashboard = Dashboard()
    class Dashboard: ConfigGroup, DashboardConfig {
        @Config({ false }) var isAccountClosingEnabled
    }
}
