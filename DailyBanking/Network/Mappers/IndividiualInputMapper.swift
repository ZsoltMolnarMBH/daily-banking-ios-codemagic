//
//  IndividiualInputMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 06..
//

import BankAPI
import Foundation

class IndividualInputMapper: Mapper<FaceKom.DataConfirmationFields, IndividualInput> {
    override func map(_ item: FaceKom.DataConfirmationFields) throws -> IndividualInput {
        return .init(
            birthData: convertBirtData(from: item),
            legalName: NameInput(firstName: item.firstName.value, lastName: item.lastName.value),
            birthName: NameInput(firstName: "", lastName: item.birthName.value),
            legalAddress: convertAddress(from: item),
            correspondenceAddress: nil,
            mobilePhone: .init(fullPhoneNumber: item.phoneNumber.value.deformatted(pattern: .phoneNumber)),
            identityCardDocument: DocumentInput(serial: item.idCardNumber.value, validUntil: item.idDateOfExpiry.value),
            addressCardDocument: DocumentInput(serial: item.addressCardNumber.value),
            mainEmail: .init(address: item.email.value)
        )
    }

    private func convertBirtData(from fields: FaceKom.DataConfirmationFields) -> BirthDataInput? {
        return .init(
            countryOfBirth: "Magyarország",
            placeOfBirth: fields.placeOfBirth.value,
            dateOfBirth: fields.dateOfBirth.value,
            motherName: fields.motherName.value
        )
    }

    private func convertAddress(from fields: FaceKom.DataConfirmationFields) -> AddressInput? {
        return .init(
            country: "",
            city: "",
            postCode: "",
            streetName: fields.address.value,
            houseNumber: ""
        )
    }
}
