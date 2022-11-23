//
//  DebugMenuItem.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2020. 07. 06..
//

import UIKit

struct DebugMenuItem {
    let title: String
    let subtitle: String?
    let action: Action?

    enum Action {
        case navigation( (UINavigationController) -> UIViewController )
        case execution( (DebugViewController, DebugMenuItem) -> Void )
    }

    init(title: String, subtitle: String? = nil, action: Action?) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
}
