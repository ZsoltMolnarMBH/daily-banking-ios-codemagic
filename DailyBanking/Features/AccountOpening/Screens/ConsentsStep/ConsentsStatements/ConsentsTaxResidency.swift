//
//  ConsentsTaxResidency.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 12..
//

import DesignKit

enum Consent {
    enum TaxResidency {
        case hungary, hungaryAbroad, abroad

        var label: String {
            switch self {
            case .hungary: return Strings.Localizable.accountOpeningTaxResidencyTypeHungary
            case .hungaryAbroad: return Strings.Localizable.accountOpeningTaxResidencyTypeHungaryAbroad
            case .abroad: return Strings.Localizable.accountOpeningTaxResidencyTypeAbroad
            }
        }
    }

    class Taxation: Equatable {
        let id = UUID().uuidString
        var country: Country
        var taxNumber: String
        var taxNumberValidationState: ValidationState = .normal

        init(country: Country  = .empty, taxNumber: String = "") {
            self.country = country
            self.taxNumber = taxNumber
        }

        static func == (lhs: Taxation, rhs: Taxation) -> Bool {
            lhs.id == rhs.id
        }
    }
}
