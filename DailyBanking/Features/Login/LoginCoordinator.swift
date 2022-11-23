//
//  LoginCoordinator.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import Foundation
import Resolver
import SwiftUI
import DesignKit

class LoginCoordinator: Coordinator {
    private var root: UIViewController?

    func start(on context: UIWindow?) {
        showWelcome(on: context)
    }

    private func showWelcome(on window: UIWindow?) {
        let welcomeScreen: LoginWelcomeScreen<LoginWelcomeScreenViewModel> = container.resolve()
        welcomeScreen.viewModel.events
            .sink { [weak self] event in
                switch event {
                case .startLogin:
                    self?.showLogin()
                }
            }
            .store(in: &disposeBag)
        let host = UIHostingController(rootView: welcomeScreen)
        self.root = host
        window?.setRootViewController(host, animated: true)
    }

    private func showLogin() {
        let title = Strings.Localizable.loginPinScreenTitle
        let enterPin: PinPadScreen<LoginEnterPinScreenViewModel> = container.resolve()
        enterPin.viewModel.analyticsName = "login_pin"
        enterPin.viewModel.onShowDeviceReset = { [weak self] in
            self?.showDeviceReset()
        }
        let host = UIHostingController(
            rootView: enterPin.navigationTitle(title)
        )
        let navigationController = BrandedNavigationController(rootViewController: host)
        navigationController.title = title
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBarStyle = .inline

        root?.present(navigationController, animated: true)
    }

    private func showDeviceReset() {
        let name = "DeviceReset"
        Modals.fullScreen.show(
            view: ResultScreen(model: .deviceDidReset { Modals.fullScreen.dismiss(name) })
                .analyticsScreenView("login_error_pin"),
            name: name,
            hapticFeedbackType: .error
        )
    }
}
