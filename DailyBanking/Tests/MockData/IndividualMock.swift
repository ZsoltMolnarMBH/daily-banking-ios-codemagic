//
//  IndividualMock.swift
//  DailyBanking
//
//  Created by ALi on 2022. 06. 26..
//

import Foundation
import BankAPI
@testable import DailyBanking

extension Individual {
    struct Mock { }
    static let mock = Mock()
}

extension Individual.Mock {
    var johnDoe: Individual {
        .init(
            legalName: .init(firstName: "John", lastName: "Doe"),
            birthName: .init(firstName: "John", lastName: "Doe"),
            birthData: .init(place: "Aba", date: DateFormatter.simple.date(from: "2000-01-02"), motherName: "Mama"),
            legalAddress: .init(country: "Magyarország", city: "Aba", postCode: "1111", streetName: "Fő utca", houseNumber: "5"),
            correspondenceAddress: nil,
            identityCard: .init(serial: "123456", validUntil: DateFormatter.simple.date(from: "2050-05-05")),
            addressCard: .init(serial: "654321", validUntil: DateFormatter.simple.date(from: "2099-12-31")),
            phoneNumber: "+36301234567",
            email: .init(address: "john@me.com", isVerified: false))
    }
}

extension IndividualFragment {
    struct Mock { }
    static let mock = Mock()
}

extension IndividualFragment.Mock {
    var johnDoe: IndividualFragment {
        .init(
            legalName: .init(firstName: "John", lastName: "Doe"),
            birthName: .init(firstName: "John", lastName: "Doe"),
            birthData: .init(countryOfBirth: "Magyarország", placeOfBirth: "Aba", dateOfBirth: "2000-01-02", motherName: "Mama"),
            legalAddress: .init(city: "Aba", country: "Magyarország", houseNumber: "5", postCode: "1111", streetName: "Fő utca"),
            correspondenceAddress: nil,
            identityCardDocument: .init(serial: "123456", type: .identityCard, validUntil: "2050-05-05"),
            addressCardDocument: .init(serial: "654321", type: .addressCard, validUntil: "2099-12-31"),
            mainEmail: .init(address: "john@me.com", verified: false),
            mobilePhone: .init(fullPhoneNumber: "+36301234567"))
    }
}
