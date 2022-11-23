//
//  ApplicationMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 06..
//

import BankAPI
import Foundation

class ApplicationMapper: Mapper<GetApplicationQuery.Data, AccountOpeningDraft> {

    let individualMapper: Mapper<IndividualFragment, Individual> = IndividualMapper()

    override func map(_ item: GetApplicationQuery.Data) throws -> AccountOpeningDraft {
        let individual = item.getApplication.individual?.fragments.individualFragment
        let consentInfo = item.getApplication.consentInfo?.fragments.consentFragment
        let kycSurvey = item.getApplication.kycSurvey?.fragments.kycSurveyFragment
        let nextStep = item.getApplication.nextStep
        let selectedProduct = item.getApplication.selectedProduct
        let dmStatements = item.getApplication.dmStatement

        return AccountOpeningDraft(
            nextStep: convertNextStep(from: nextStep),
            selectedProduct: selectedProduct,
            individual: try convertIndividual(from: individual),
            statements: convertConsents(from: consentInfo, dmStatement: dmStatements),
            kycSurvey: convertKycSurvey(from: kycSurvey),
            signInfo: convertSignInfo(from: item.getApplication.signInfo),
            contractID: item.getApplication.contractInfo?.fragments.contractInfoFragment.contractId
        )
    }

    private func convertSignInfo(from signInfo: GetApplicationQuery.Data.GetApplication.SignInfo?) -> AccountOpeningDraft.SignInfo? {
        guard let signInfo = signInfo, let signedAt = DateFormatter.simple.date(optional: signInfo.signedAt) else { return nil }
        return .init(signedAt: signedAt)
    }

    private func convertDMStatements(from dmStatement: GetApplicationQuery.Data.GetApplication.DmStatement?) -> AccountOpeningDraft.Statements.DMStatement? {
        guard let dmStatement = dmStatement else { return nil }
        return .init(push: dmStatement.push ?? false, email: dmStatement.email ?? false, robinson: dmStatement.robinson ?? false)
    }

    private func convertConsents(from info: ConsentFragment?, dmStatement: GetApplicationQuery.Data.GetApplication.DmStatement?) -> AccountOpeningDraft.Statements? {
        guard let info = info else { return nil }
        return .init(
            isPep: info.isPep,
            taxation: convertTaxation(from: info),
            taxResidency: convertTaxResidency(from: info.taxResidency),
            acceptTerms: info.acceptTerms ?? false,
            acceptConditions: info.acceptConditions ?? false,
            acceptPrivacyPolicy: info.acceptPrivacyPolicy ?? false,
            dmStatement: convertDMStatements(from: dmStatement)
        )
    }

    private func convertTaxation(from info: ConsentFragment?) -> [AccountOpeningDraft.Statements.Taxation] {
        guard let info = info else { return [] }

        return info.taxation.map {
            .init(country: $0.fragments.taxationFragment.country, taxNumber: $0.fragments.taxationFragment.taxNumber ?? "")
        }
    }

    private func convertKycSurvey(from kycSurvey: KycSurveyFragment?) -> AccountOpeningDraft.KycSurvey? {
        guard let kycSurvey = kycSurvey else { return nil }
        return AccountOpeningDraft.KycSurvey.init(
            incomingSources: .init(salary: kycSurvey.incomingSources?.fragments.incomingSourcesFragment.salary ?? false, other: nil),
            depositPlan: .init(
                amountFrom: kycSurvey.depositPlan?.fragments.planFragment.amountFrom ?? 0,
                amountTo: kycSurvey.depositPlan?.fragments.planFragment.amountTo),
            transferPlan: .init(
                amountFrom: kycSurvey.transferPlan?.fragments.planFragment.amountFrom ?? 0,
                amountTo: kycSurvey.transferPlan?.fragments.planFragment.amountTo)
        )
    }

    private func convertIndividual(from individual: IndividualFragment?) throws -> Individual? {
        guard let individual = individual else { return nil }
        return try individualMapper.map(individual)
    }

    private func convertNextStep(from nextStep: OnboardingNextStepType) -> AccountOpeningDraft.Step {
        switch nextStep {
        case .accountPackageSelection:
            return .accountPackageSelection
        case .personalData:
            return .personalData
        case .consents:
            return .consents
        case .generateContract:
            return .generateContract
        case .signContract:
            return .signContract
        case .accountOpening:
            return .accountOpening
        case .finalize:
            return .finalize
        case .__unknown:
            return .unknown
        }
    }

    private func convertTaxResidency(from taxResidency: TaxResidency?) -> Consent.TaxResidency? {
        switch taxResidency {
        case .hungary:
            return .hungary
        case .abroad:
            return .abroad
        case .hungaryAbroad:
            return .hungaryAbroad
        case .__unknown:
            return nil
        case .none:
            return nil
        }
    }
}
