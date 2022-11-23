//
//  LegalDocumentType.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 12. 02..
//

import Foundation

enum LegalDocumentType {
    case conditionList, contractTemplate, privacyStatement

    var title: String {
        switch self {
        case .conditionList:
            return Strings.Localizable.accountOpeningPackageMoreDetailsConditions
        case .contractTemplate:
            return Strings.Localizable.accountOpeningPackageMoreDetailsContractSample
        case .privacyStatement:
            return Strings.Localizable.accountOpeningPackageMoreDetailsPrivacyNotice
        }
    }

    var url: String {
        switch self {
        case .conditionList:
            return "https://ms-onboarding-test.dev.sandbox-mbh.net/static/kondicios_lista_FF_0527.pdf"
        case .contractTemplate:
            return "https://ms-onboarding-test.dev.sandbox-mbh.net/static/fizetesi_szamla_szerzodes_online_szamlanyitashoz_MINTA_v3_FF_0527.pdf"
        case .privacyStatement:
            return "https://ms-onboarding-test.dev.sandbox-mbh.net/static/data_protection_management_FF_0527.pdf"
        }
    }
}
