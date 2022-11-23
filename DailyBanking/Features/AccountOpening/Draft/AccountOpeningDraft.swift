//
//  AccountSetupDraft.swift
//  app-daily-banking-ios
//
//  Created by Alexa Mark on 2021. 11. 15..
//

import Foundation

struct AccountOpeningDraft {
    enum Step {
        case accountPackageSelection, personalData, consents, generateContract, signContract, finalize, accountOpening, unknown
    }

    struct Statements: Equatable {
        struct DMStatement: Equatable {
            let push: Bool
            let email: Bool
            let robinson: Bool

            var isValid: Bool {
                robinson == true || (push || email)
            }
        }

        struct Taxation: Equatable {
            let country: String
            let taxNumber: String
        }

        var isPep: Bool
        var taxation: [Taxation]
        var taxResidency: Consent.TaxResidency?
        var acceptTerms: Bool
        var acceptConditions: Bool
        var acceptPrivacyPolicy: Bool
        var dmStatement: DMStatement?

        static var new: Statements {
            .init(
                isPep: false,
                taxation: [],
                taxResidency: nil,
                acceptTerms: false,
                acceptConditions: false,
                acceptPrivacyPolicy: false
            )
        }

        var isValid: Bool {
            !isPep && !taxation.isEmpty && acceptPrivacyPolicy && acceptTerms && acceptConditions && (dmStatement?.isValid ?? true)
        }
    }

    struct SignInfo {
        var signedAt: Date
    }

    struct KycSurvey {
        struct IncomingSources {
            let salary: Bool
            let other: String?
        }

        struct Plan {
            let amountFrom: Int?
            let amountTo: Int?
            let currency: String = "HUF"
        }

        var incomingSources: IncomingSources?
        var depositPlan: Plan?
        var transferPlan: Plan?

        var isValid: Bool {
            guard let incomingSources = incomingSources else { return false }
            if incomingSources.salary == false && incomingSources.other == nil { return false }
            return depositPlan != nil && transferPlan != nil
        }

        static var new: KycSurvey {
            .init(incomingSources: nil, depositPlan: nil, transferPlan: nil)
        }
    }

    var nextStep: Step
    var selectedProduct: String?

    var individual: Individual?
    var statements: Statements?
    var kycSurvey: KycSurvey?
    var signInfo: SignInfo?

    var contractID: String?
    var accountID: String?

    var emailOperationBlockedUntil: Date?
    var selectedCountry: Country?
}
