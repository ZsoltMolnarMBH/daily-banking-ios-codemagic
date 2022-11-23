//
//  PhoneNumberValidator.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 28..
//

import Foundation
import DesignKit

class PhoneNumberValidator {

    let allowedRegions = ["20", "30", "31", "50", "55", "70"]

    func isValid(phoneNumber: String) -> Bool {
        let validRegion = allowedRegions.contains(where: { phoneNumber.starts(with: $0) })
        return validRegion && phoneNumber.count == 9
    }

    func validationState(from phoneNumber: String) -> ValidationState {
        let deformatted = phoneNumber.deformatted(pattern: .phoneNumber)
        let isValid = PhoneNumberValidator().isValid(phoneNumber: deformatted)
        let state: ValidationState
        if isValid {
            state = .loading
        } else if deformatted.count < 9 {
            state = .normal
        } else {
            state = .error(text: Strings.Localizable.commonErrorWrongNumber)
        }
        return state
    }
}
