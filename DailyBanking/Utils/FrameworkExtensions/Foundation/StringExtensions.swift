//
//  String+Extensions.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 25..
//

import Foundation

extension String {
    func filtered(characterSet: CharacterSet) -> String {
        let filtered = self.unicodeScalars.filter { characterSet.contains($0) }
        return String(filtered)
    }

    func contains(anyOf characterSet: CharacterSet) -> Bool {
        for character in self.unicodeScalars {
            if characterSet.contains(character) {
                return true
            }
        }
        return false
    }

    func contains(only characterSet: CharacterSet) -> Bool {
        return unicodeScalars.allSatisfy { characterSet.contains($0) }
    }

    func removing(prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    func removing(suffix: String) -> String {
        guard hasSuffix(suffix) else { return self}
        return String(dropLast(suffix.count))
    }

    func matches(pattern regExp: RegExp) -> Bool {
        let result = range(
            of: regExp.pattern,
            options: .regularExpression
        )

        return result != nil
    }
}
