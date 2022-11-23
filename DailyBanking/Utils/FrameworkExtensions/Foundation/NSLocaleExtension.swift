//
//  LocaleExtension.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 14..
//

import Foundation

extension NSLocale {
    static func countryName(for countryCode: String) -> String? {
        (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode)
    }
}
