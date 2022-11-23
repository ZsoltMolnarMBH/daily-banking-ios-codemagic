//
//  Placeholders.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 13..
//

import SwiftUI

struct ListPlaceholderData: Identifiable {
    let id = UUID().uuidString
}

extension View {
    func makePlaceholderdata(count: Int) -> [ListPlaceholderData] {
        return (1...count).map { _ in ListPlaceholderData() }
    }
}
