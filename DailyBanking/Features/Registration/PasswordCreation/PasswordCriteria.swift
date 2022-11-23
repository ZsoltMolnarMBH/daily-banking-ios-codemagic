//
//  PasswordCriteria.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 28..
//

import Foundation

enum PasswordCriteria {
    case lowerCaseLetter
    case upperCaseLetter
    case number
    case length(Int)

    func isFulfilled(for password: String) -> Bool {
        switch self {
        case .lowerCaseLetter:
            return password.contains(anyOf: .lowercaseLetters)
        case .upperCaseLetter:
            return password.contains(anyOf: .uppercaseLetters)
        case .number:
            return password.contains(anyOf: .decimalDigits)
        case .length(let minimumLength):
            return password.count >= minimumLength
        }
    }
}

private extension String {
    func fulfills(criteria: PasswordCriteria) -> Bool {
        return criteria.isFulfilled(for: self)
    }
}
