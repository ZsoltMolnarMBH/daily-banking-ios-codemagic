//
//  TextFormatter.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 25..
//

import Foundation

protocol TextFormatter {
    func format(text: String) -> String
    func deformat(text: String) -> String
}

extension String {
    func formatted(pattern: PatternFormatter) -> String {
        return pattern.format(text: self)
    }

    func deformatted(pattern: PatternFormatter) -> String {
        return pattern.deformat(text: self)
    }
}

extension PatternFormatter {
    static let phoneNumber = PatternFormatter(pattern: "## ### ####")
    static let phoneNumberWithCountryCode = PatternFormatter(pattern: "### ## ### ####")
    static let accountNumber = PatternFormatter(pattern: "######## - ######## - ########", allowExceedingLength: true)
    static let iban = PatternFormatter(pattern: "#### #### #### #### #### #### ####", allowExceedingLength: true)
    static let cardNumber = PatternFormatter(pattern: "#### #### #### ####")
}

class PatternFormatter: TextFormatter {
    private let allowExceedingLength: Bool
    private let wildCard: Character
    private let pattern: [Character]
    private lazy var formatCharacters: CharacterSet = {
        var pattern = self.pattern
        pattern.removeAll { $0 == wildCard }
        return CharacterSet(charactersIn: String(pattern))
    }()

    init(pattern: String, wildCard: Character = "#", allowExceedingLength: Bool = false) {
        self.wildCard = wildCard
        self.pattern = Array(pattern)
        self.allowExceedingLength = allowExceedingLength
    }

    func format(text: String) -> String {
        let deformatted = deformat(text: text)
        var formatted: [Character] = []

        var patternOffset = 0
        deformatted.enumerated().forEach { stringIndex, character in
            var patternIndex = stringIndex + patternOffset
            guard pattern.indices.contains(patternIndex) else {
                if allowExceedingLength {
                    formatted.append(character)
                }
                return
            }

            while pattern[patternIndex] != wildCard {
                formatted.append(pattern[patternIndex])
                patternOffset += 1
                patternIndex = stringIndex + patternOffset
            }
            formatted.append(character)
        }

        return String(formatted)
    }

    func deformat(text: String) -> String {
        let filtered = text.unicodeScalars.filter { !formatCharacters.contains($0) }
        return String(filtered)
    }
}

extension String {
    func formatted(dateReformatter: DateStringReformatter) -> String {
        return dateReformatter.format(text: self)
    }
}

extension DateStringReformatter {
    static let userFacing = DateStringReformatter(source: .simple, result: .userFacing)
}

class DateStringReformatter: TextFormatter {
    let source: DateFormatter
    let result: DateFormatter

    init(source: DateFormatter, result: DateFormatter) {
        self.source = source
        self.result = result
    }

    func format(text: String) -> String {
        guard let date = DateFormatter.simple.date(from: text) else { return text }
        return DateFormatter.userFacing.string(from: date)
    }

    func deformat(text: String) -> String {
        guard let date = DateFormatter.userFacing.date(from: text) else { return text }
        return DateFormatter.simple.string(from: date)
    }
}
