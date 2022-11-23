//
//  GetIndividualMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 17..
//

import BankAPI
import Foundation

class IndividualMapper: Mapper<IndividualFragment, Individual> {
    override func map(_ item: IndividualFragment) throws -> Individual {
        let legalName = item.legalName?.fragments.nameFragment
        let birthName = item.birthName?.fragments.nameFragment
        let legalAddress = item.legalAddress?.fragments.addressFragment
        let corrAddress = item.correspondenceAddress?.fragments.addressFragment
        let idCard = item.identityCardDocument?.fragments.documentFragment
        let addressCard = item.addressCardDocument?.fragments.documentFragment

        return .init(legalName: convertName(from: legalName),
                     birthName: convertName(from: birthName),
                     birthData: convertBirthData(from: item.birthData),
                     legalAddress: convertAddress(from: legalAddress),
                     correspondenceAddress: convertAddress(from: corrAddress),
                     identityCard: convertDocument(from: idCard),
                     addressCard: convertDocument(from: addressCard),
                     phoneNumber: item.mobilePhone.fragments.phoneFragment.fullPhoneNumber,
                     email: convertEmail(from: item.mainEmail.fragments.emailFragment)
            )
    }

    private func convertEmail(from fragment: EmailFragment) -> Email {
        .init(address: fragment.address, isVerified: fragment.verified ?? false)
    }

    private func convertName(from fragment: NameFragment?) -> Name? {
        guard let fragment = fragment else { return nil }
        return .init(firstName: fragment.firstName, lastName: fragment.lastName)
    }

    private func convertBirthData(from fragment: IndividualFragment.BirthDatum?) -> BirthData? {
        guard let fragment = fragment else { return nil }
        return .init(
            place: fragment.placeOfBirth,
            date: DateFormatter.simple.date(optional: fragment.dateOfBirth),
            motherName: fragment.motherName
        )
    }

    private func convertAddress(from fragment: AddressFragment?) -> Address? {
        guard let fragment = fragment else { return nil }
        return .init(
            country: fragment.country,
            city: fragment.city,
            postCode: fragment.postCode,
            streetName: fragment.streetName,
            houseNumber: fragment.houseNumber
        )
    }

    private func convertDocument(from fragment: DocumentFragment?) -> Document? {
        guard let fragment = fragment else { return nil }
        return .init(serial: fragment.serial, validUntil: DateFormatter.simple.date(optional: fragment.validUntil))
    }
}
