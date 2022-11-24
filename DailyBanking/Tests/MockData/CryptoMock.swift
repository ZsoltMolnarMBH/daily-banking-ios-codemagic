//
//  CryptoMock.swift
//  DailyBanking
//
//  Created by Zsombor Szabo on 2022. 03. 08..
//

import Foundation
import CryptoKit
@testable import DailyBanking

enum CryptoMock {
    private static let preparedToken = "AAACAN+qMyxMW5mlcZSjMy/ifb09gg7AJ/kKKLsfuWgvzvNBBaRWLlguvtpZ6NW1Epz+0WLGkyqX+TSFtNCRBYCnDuAHMjGE93nmKmFlAWSFL79Dh+UuTxDLBatBWjozvSd8VvVu6v4RkO7jKI8XXRB1GzDCOHv1p8OlVYty7+ss58GdJoHU0O3gn5lxXhuRh7KR0ZvlsjReWBIFRqz2ekzNFWYRKHctHE/R+Mb5YJfYTO/Fyr//QAgqmwvMRhwbP2JQxOoZ7IpyM/88WU++37120vrEiPNNJEydv+12aEeYxtPf2KCcyPM5n1Wb6ymeNp4ZvW9eW2GQlVwMxKUXhB4Az0btgVp4hNu5BlDpD6jjfzI6+7wI/soigu18beev/3AwYcTHCENHVOw6ksT3sySVxP10jXJlzeg0AxLHSU6jLa3v03nneLcCKK+F+4ltLvF3cTxf/RTehh4L6EOs84hTPnisv1sMQKs7dUKkwbtyOivNsy5R1Hxx/k9WSyhSu5o7ZeGB1cBHwCkTorc07HHK+pJRnPEaqLra0fFiXgXh6cKdcsfL33O7opyqlATdRtuhouR3Byp90I4BAKpAzfMCsaivMeldT/1hNldDnWPGK7JkhwAcNKE5kjvdHQedPtNk4VWXY3l4t1iulXWUKHoafLqMKaE3TQQNA2f/yRXXWhb5AAAA46BiYowSFttfNCf0qtyoGUUX8FjMZDeGn3hT4KMd25swPnJegE13jKwVaqgdGjNd6fTasCL14bBvbE71UR2KGuBpbiD4iVf4UFHu9qI3nS1et7zViH0MFN1LxMpxfRxUoJWZ8kB1jh4EIZurN4Rq65UkkUlrWIX7ctcEI4Bjm/z+mxyZgjUvYqLyJW2le0Zk7ewMxR0GXNqRhF8sbRpo4IOYQbXjVuOQbUCvNU2keJbJxO1izljRIYNHLKSCy3LEzDxrzDZFCi7hOzmj5zJWOuaoYy+AuvLGhYcvcgVEnmtkBrAxAAAADHBhc3N3b3JkcGFzcwAAAA90aGlzaXNhcGFzc3dvcmQ="
    private static let serverPublicKey = "-----BEGIN PUBLIC KEY-----\nMIGbMBAGByqGSM49AgEGBSuBBAAjA4GGAAQBPWtsOXdD7OO/W1glVssEMTV76vqD\nSp15U0HGaES59gqIxiBoj8LBZQtVc/aIDmB0p8ztEQjZDkyxf0kVDTOyRkEAnCH9\n16BMF6oTRtHWduS7NYmGEz0oBonigjB0bBraLrHZEp7rwJbtjCXI6ZudyLlj9zPa\nRjMpQrQ20FqwnkZPzaM=\n-----END PUBLIC KEY-----"
    private static let clientPrivateKey = try! P521.KeyAgreement.PrivateKey(pemRepresentation: "-----BEGIN PRIVATE KEY-----\nMIHuAgEAMBAGByqGSM49AgEGBSuBBAAjBIHWMIHTAgEBBEIBMdZVAWBmIZC3Fx97\n99C+OeKEOZRRe4ybFNvwMizzMg/I/OrI68t5FnRcC7bO1rGUSU9hNjh6QXSBDmPd\nXtSg1H2hgYkDgYYABAEr80kANEpTOhQj9/Kq4f15XOf0rgCsUk727rFKOFoG3akm\nQjM2yNigLDR4X70PwKb/tswxKbhqK1bPSDP9BPB/UwBB/6+gXv1muVJzNOaTuWkh\nyS/a8eHePX86ydnPCjM/VlIzAljpHGKt34/0Ql2kn4TlQQA5S4DCXvRBk+NSwSo7\n2g==\n-----END PRIVATE KEY-----")
    static let hashedDID = "3620cf7280e5359d670032c3c5ab761e9eef75a7f8b83cdae9bddabee1170146d7a2f55834f9bb558f314e16d6be84e5a46bb7cf5fb4e759f5c42061d3006924"
    static func validKeyFile(pin: String = "121212") -> KeyFile {
        //let otpGen = CryptoOtpGen()
        let otpGen = OtpGeneratorMock()
        return try! otpGen.createKeyFile(token: CryptoMock.preparedToken, privateKey: CryptoMock.clientPrivateKey, publicKeyPem: CryptoMock.serverPublicKey, mpin: pin, deviceId: hashedDID)
    }
}
