//
//  PhoneNumberValidity.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 06. 14..
//

import Foundation

enum PhoneNumberValidity: Equatable {
    case badFormat
    case notAllowed
    case loading
    case normal
    case success
}
