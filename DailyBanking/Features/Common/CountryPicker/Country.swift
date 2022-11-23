//
//  Country.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 13..
//

import Foundation

struct Country: Equatable {
    var code: String
    var name: String
}

extension Country {
    static let empty: Self = .init(code: "", name: "")
}
