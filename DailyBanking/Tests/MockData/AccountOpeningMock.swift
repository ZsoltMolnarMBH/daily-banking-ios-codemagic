//
//  AccountOpeningMock.swift
//  DailyBankingTests
//
//  Created by ALi on 2022. 06. 26..
//

import Foundation
import BankAPI
@testable import DailyBanking

extension AccountOpeningDraft.Statements {
    struct Mock { }
    static let mock = Mock()
}

extension AccountOpeningDraft.Statements.Mock {
    var testStatement: AccountOpeningDraft.Statements {
        .init(
            isPep: true,
            taxation: [.init(country: "hu", taxNumber: "123456")],
            taxResidency: .hungary,
            acceptTerms: true,
            acceptConditions: true,
            acceptPrivacyPolicy: true,
            dmStatement: .init(push: true, email: false, robinson: true))
    }
}

extension KycSurveyFragment.Mock {
    var testKycSurveyFragment: KycSurveyFragment {
        .init(
            incomingSources: .init(salary: true, other: "other"),
            depositPlan: .init(amountFrom: 100_000, amountTo: 250_000),
            transferPlan: .init(amountFrom: 10_000, amountTo: 150_000))
    }
}

extension KycSurveyInput {
    struct Mock { }
    static let mock = Mock()
}

extension KycSurveyInput.Mock {
    var testKycSurveyInput: KycSurveyInput {
        .init(
            incomingSources: .init(salary: true, other: "other"),
            depositPlan: .init(amountFrom: 100_000, amountTo: 250_000, currency: "HUF"),
            transferPlan: .init(amountFrom: 10_000, amountTo: 150_000, currency: "HUF"))
    }
}

extension AccountOpeningDraft.KycSurvey {
    struct Mock { }
    static let mock = Mock()
}

extension AccountOpeningDraft.KycSurvey.Mock {
    var testKycSurvey: AccountOpeningDraft.KycSurvey {
        .init(
            incomingSources: .init(salary: true, other: "other"),
            depositPlan: .init(amountFrom: 100_000, amountTo: 250_000),
            transferPlan: .init(amountFrom: 10_000, amountTo: 150_000))
    }
}

extension ConsentFragment {
    struct Mock { }
    static let mock = Mock()
}

extension ConsentFragment.Mock {
    var testStatementFragment: ConsentFragment {
        .init(
            isPep: true,
            taxation: [.init(country: "hu", taxNumber: "123456")],
            acceptTerms: true,
            acceptConditions: true,
            acceptPrivacyPolicy: true,
            taxResidency: .hungary)
    }
}

extension ConsentInfoInput {
    struct Mock { }
    static let mock = Mock()
}

extension ConsentInfoInput.Mock {
    var testConsentInfoInput: ConsentInfoInput {
        .init(
            isPep: true,
            taxation: [.init(country: "hu", taxNumber: "123456")],
            acceptTerms: true,
            acceptConditions: true,
            acceptPrivacyPolicy: true)
    }
}

extension KycSurveyFragment {
    struct Mock { }
    static let mock = Mock()
}
