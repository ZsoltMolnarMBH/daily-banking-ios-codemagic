//
//  Coordinator+UnavailableFeature.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 18..
//

import UIKit
import SwiftUI
import DesignKit

extension Coordinator {
    func modalUnavailableScreen(on context: UIViewController, title: String, body: String, screenViewName: String, onClose: @escaping () -> Void) {
        let navigationController = BrandedNavigationController()
        let screen = InfoScreen(model: .unavailableFeature(message: body, action: { [weak context] in
                onClose()
                context?.dismiss(animated: true)
            }))
            .navigationTitle(title)
            .analyticsScreenView(screenViewName)
            .addClose { [weak context] in
                onClose()
                context?.dismiss(animated: true)
            }
        let host = UIHostingController(rootView: screen)
        host.title = title
        navigationController.viewControllers = [host]
        context.present(navigationController, animated: true)
    }
}
