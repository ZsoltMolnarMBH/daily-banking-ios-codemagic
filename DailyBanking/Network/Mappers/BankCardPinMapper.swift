//
//  BankCardPinMapper.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 31..
//

import Foundation
import BankAPI
import Resolver

class BankCardPinMapper: Mapper<(data: CardPinQuery.Data, key: [UInt8]), String?> {
    @Injected private var cipher: BankCardCipher

    override func map(_ item: (data: CardPinQuery.Data, key: [UInt8])) throws -> String? {
        let vector = item.data.cardPin.encryptedPin.fragments.secureFlowFragment.iv
        let data = item.data.cardPin.encryptedPin.fragments.secureFlowFragment.data
        guard let pin = try? cipher.decryptData(
            sessionKey: item.key,
            aesIv: vector,
            data: data
        ) else {
            throw makeError(item: item, reason: "Cannot decrypt pinCode")
        }

        return cipher.pinCodeFromIso2(pin)
    }
}
