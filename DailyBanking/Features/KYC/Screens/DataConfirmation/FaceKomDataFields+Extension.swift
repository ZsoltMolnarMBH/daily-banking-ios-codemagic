//
//  FaceKomDataFields+Extension.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 18..
//

import Foundation

extension FaceKom.DataConfirmationFields {
    var contactFields: [FaceKom.DataField] {
        [phoneNumber, email]
    }

    var personalDataFields: [FaceKom.DataField] {
        [firstName, lastName, birthName, dateOfBirth, motherName, placeOfBirth]
    }

    var addressFields: [FaceKom.DataField] {
        [address]
    }

    var documentFields: [FaceKom.DataField] {
        [idCardNumber, idDateOfExpiry, addressCardNumber]
    }
}
