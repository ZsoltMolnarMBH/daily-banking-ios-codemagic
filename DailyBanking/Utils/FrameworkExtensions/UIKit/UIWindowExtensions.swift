//
//  WindowExtensions.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 13..
//

import UIKit
import SwiftUI

extension UIWindow {
    static var keyWindow: UIWindow? {
            UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }
                .first
        }

    func setRootViewController(_ viewController: UIViewController, animated: Bool = false) {
        rootViewController = viewController

        guard animated else { return }
        UIView.transition(
            with: self,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {}
        )
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIWindow.keyWindow?.safeAreaInsets.edgeInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var keyWindowSafeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var edgeInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
