//
//  MainCoordinator+PinVerificationDisplay.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 04..
//

import SwiftUI
import UIKit
import SwiftEntryKit

extension MainCoordinator: PinVerificationDisplay {
    func showPinVerification(
        renewSession: Bool,
        title: String,
        screenName: String,
        then handler: @escaping (PinCode?) -> Void
    ) {
        Modals.pinPadOverlay.dismissAll()
        Modals.bottomAlert.dismissAll()
        Modals.bottomInfo.dismissAll()
        let name = "PinVerification"
        let screen: PinPadScreen<VerifyPinViewModel> = container.resolve()
        let userAction = container.resolve(UserAction.self)
        if renewSession {
            screen.viewModel.method = userAction.renewSession(pin:)
        } else {
            screen.viewModel.method = userAction.verify(pin:)
        }
        screen.viewModel.analyticsName = screenName
        screen.viewModel.onDeinit = {
            handler(nil)
        }
        screen.viewModel.onForceLogout = { [weak self] in
            self?.onForceLogout()
        }
        screen.viewModel.onPinVerified = { pinCode in
            Modals.pinPadOverlay.dismiss(name)
            handler(pinCode)
        }
        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .if(!renewSession) { screen in
                    screen.addClose {
                        Modals.pinPadOverlay.dismiss(name)
                    }
                }
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        Modals.pinPadOverlay.show(viewController: UINavigationController(rootViewController: hostingController), name: name)
    }
}
