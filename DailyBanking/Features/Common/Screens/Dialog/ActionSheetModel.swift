//
//  ActionSheetModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 19..
//

import Foundation

struct ActionSheetModel: Equatable {
    let title: String
    let items: [Item]

    struct Item: Equatable, Identifiable {
        var id: String { title }
        let title: String
        let subtitle: String?
        let iconName: String?
        let action: () -> Void

        init(title: String, subtitle: String? = nil, iconName: String?, action: @escaping () -> Void) {
            self.title = title
            self.subtitle = subtitle
            self.iconName = iconName
            self.action = action
        }

        static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
        }
    }
}
