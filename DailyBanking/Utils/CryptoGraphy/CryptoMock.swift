//
//  OtpGenMock.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 11. 23..
//

import Foundation
import CryptoSwift
import CryptoKit
import CommonCrypto
import SwiftUI

struct ParamFile: Codable {
    let iv: String
    let ocraSuite: String
    let ocraPassword: String
    let expirationDate: Int
}

struct KeyFile: Codable {
    let encryptedKey: Data
    let iv: Data
    let salt: Data
    let ocraSuite: String
    let ocraPassword: String
    let expirationDate: Int
}

struct Ocra {
    let message: Array<UInt8>
    let codeDigits: Int
}

protocol OtpGenerator: AutoMockable {
    func createKeyFile(token: String, privateKey: P521.KeyAgreement.PrivateKey, publicKeyPem: String, mpin: String, deviceId: String) throws -> KeyFile
    func createNewKeyFile(oldKeyFile: KeyFile, oldMpin: String, newMpin: String, deviceId: String) throws -> KeyFile
    func createOtp(keyFile: KeyFile, mpin: String, deviceId: String) throws -> String
}

protocol BankCardCipher: AutoMockable {
    func randomSessionKey() -> [UInt8]
    func encryptSessionKeyRSA(_ sessionKey: [UInt8]) throws -> String
    func decryptData(sessionKey: [UInt8], aesIv: String, data: String) throws -> String
    func pinCodeFromIso2(_ iso2: String) -> String
    func encryptPinCode(pinCode: String, sessionKey: [UInt8]) throws -> (String, String)
}
