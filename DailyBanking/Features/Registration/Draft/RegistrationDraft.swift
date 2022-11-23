//
//  RegistrationDraft.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 04..
//

import Foundation

struct RegistrationDraft {
    enum FlowKind {
        case registration
        case deviceActivation
    }
    struct OtpInfo: Equatable {
        var expireTime: Date
        var nextRequestTime: Date
        var responseTime: Date
        var remainingResendAttempts: Int?
    }
    var flowKind: FlowKind?
    var isTermsAccepted = false
    var isPrivacyAccepted = false
    var phoneNumber: String?
    var email: String?
    var smsOtpInfo: OtpInfo?
    var pinCode: PinCode?
    var keyFile: KeyFile?
}
