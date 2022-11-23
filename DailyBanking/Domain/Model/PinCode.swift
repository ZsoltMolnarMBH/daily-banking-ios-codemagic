//
//  PinCode.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 11. 30..
//

import Foundation

typealias PinCode = [Int]

extension PinCode {
    var stringValue: String {
        map {"\($0)"}.reduce("") { $0 + $1 }
    }

    func validate(requiredToMatch: PinCode?, forbiddenToMatch: PinCode? = nil) -> NewPinError? {
        if let requiredToMatch = requiredToMatch, self != requiredToMatch {
            return .mismatchingRequired
        }

        if forbiddenToMatch != nil, self == forbiddenToMatch {
            return .matchingForbidden
        }

        let set = Set<Int>(self)
        if set.count == 1 {
            return .matchingCharacters
        }

        let sequence = "0123456789"
        let pinString = self.map { "\($0)" }.joined()
        if sequence.contains(pinString) || String(sequence.reversed()).contains(pinString) {
            return .sequencialCharacters
        }

        return nil
    }
}

enum NewPinError: Error {
    case matchingCharacters
    case sequencialCharacters
    case mismatchingRequired
    case matchingForbidden
}
