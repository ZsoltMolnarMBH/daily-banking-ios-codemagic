//
//  AuthenticationKey.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 11. 30..
//

import Foundation

struct AuthenticationKey: Codable {
    /// Primary authentication identifier (for example: phone number)
    let id: String
    let keyFile: KeyFile
}
