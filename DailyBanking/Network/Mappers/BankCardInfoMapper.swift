//
//  BankCardInfoMapper.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 27..
//

import Foundation
import BankAPI
import Resolver

class BankCardInfoMapper: Mapper<(data: CardDetailsQuery.Data.CardDetail, key: [UInt8]), BankCardInfo> {

    @Injected private var cipher: BankCardCipher

    override func map(_ item: (data: CardDetailsQuery.Data.CardDetail, key: [UInt8])) throws -> BankCardInfo {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yymm"
        inputFormatter.locale = Locale(identifier: "hu")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "mm/yy"
        outputFormatter.locale = Locale(identifier: "hu")

        guard let cardNumber = try? cipher.decryptData(
            sessionKey: item.key,
            aesIv: item.data.encryptedPan.fragments.secureFlowFragment.iv,
            data: item.data.encryptedPan.fragments.secureFlowFragment.data
        ) else {
            throw makeError(item: item, reason: "Cannot decrypt cardNumber")
        }

        guard let cvc = try? cipher.decryptData(
            sessionKey: item.key,
            aesIv: item.data.encryptedCvc.fragments.secureFlowFragment.iv,
            data: item.data.encryptedCvc.fragments.secureFlowFragment.data
        ) else {
            throw makeError(item: item, reason: "Cannot decrypt cvc")
        }

        guard let valid = inputFormatter.date(from: item.data.expDate) else {
            throw makeError(item: item, reason: "Cannot parse validity date")
        }

        return .init(
            cardNumber: cardNumber,
            cvc: cvc,
            valid: outputFormatter.string(from: valid),
            name: item.data.nameOnCard)
    }
}
