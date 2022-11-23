//
//  Environment.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 04. 08..
//

import Foundation

struct RemoteEnvironment: Codable { // SwiftUI already reserved the name `Environment` :(
    enum Name: String, Codable {
        case development, chaosTest, vpnDev
    }
    let name: Name
    let graphQLEndpoint: URL
}
