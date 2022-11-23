//
//  LocalizedName.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 19..
//

import Foundation

protocol LocalizedName {
    var firstName: String { get }
    var lastName: String { get }
}

extension LocalizedName {
    private var nameComponents: PersonNameComponents {
        PersonNameComponents(givenName: firstName, familyName: lastName)
    }

    var localizedName: String {
        PersonNameComponentsFormatter.localized.string(from: nameComponents)
    }

    var initials: String {
        PersonNameComponentsFormatter.abbreviated.string(from: nameComponents)
    }
}

extension PersonNameComponentsFormatter {
    static let abbreviated: PersonNameComponentsFormatter = {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .abbreviated
        return formatter
    }()

    static let localized: PersonNameComponentsFormatter = {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .default
        return formatter
    }()
}
