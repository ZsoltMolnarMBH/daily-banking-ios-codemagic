//
//  BackgroundSnapshot.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 02..
//

import Foundation
import SwiftUI
import UIKit

protocol FullScreenCover {
    func show()
    func hide()
}

class WindowCover<Content: View>: FullScreenCover {
    private let content: () -> Content
    private var popupWindow: UIWindow?
    private var windowScene: UIWindowScene? {
        UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first as? UIWindowScene
    }

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func show() {
        if let windowScene = windowScene {
            popupWindow = UIWindow(windowScene: windowScene)
        } else {
            popupWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        let rootController = UIHostingController(rootView: content())
        rootController.view.backgroundColor = .clear
        popupWindow?.rootViewController = rootController
        popupWindow?.windowLevel = .alert + 10
        popupWindow?.backgroundColor = .clear
        popupWindow?.isHidden = false
    }

    func hide() {
        popupWindow?.isHidden = true
        popupWindow = nil
    }
}
