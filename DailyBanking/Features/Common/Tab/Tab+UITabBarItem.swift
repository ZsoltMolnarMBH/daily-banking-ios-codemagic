//
//  Tab+UITabBarItem.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 06. 23..
//

import Foundation
import DesignKit
import UIKit

private var associateKey: Void?

public extension UITabBarItem {
    var name: String? {
        get {
            return objc_getAssociatedObject(self, &associateKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &associateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension Tab {
    var tabBarItem: UITabBarItem {
        let item: UITabBarItem
        switch self {
        case .dashboard:
            item = UITabBarItem(
                title: Strings.Localizable.mainBottomNavigationDashboard,
                image: UIImage(named: DesignKit.ImageName.dashboard.rawValue),
                selectedImage: UIImage(named: DesignKit.ImageName.dashboard.rawValue)
            )
        case .transactionHistory:
            item = UITabBarItem(
                title: Strings.Localizable.mainBottomNavigationTransactions,
                image: UIImage(named: DesignKit.ImageName.calendar.rawValue),
                selectedImage: UIImage(named: DesignKit.ImageName.calendar.rawValue)
            )
        case .help:
            item = UITabBarItem(
                title: Strings.Localizable.mainBottomNavigationContact,
                image: UIImage(named: DesignKit.ImageName.help.rawValue),
                selectedImage: UIImage(named: DesignKit.ImageName.help.rawValue)
            )
        }
        item.name = self.rawValue
        return item
    }
}
