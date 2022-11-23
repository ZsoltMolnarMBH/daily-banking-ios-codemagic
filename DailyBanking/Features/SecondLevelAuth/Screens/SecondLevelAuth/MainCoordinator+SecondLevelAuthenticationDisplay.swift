//
//  MainCoordinator+Second.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 04..
//

import Combine
import SwiftUI
import SwiftEntryKit
import UIKit

extension MainCoordinator: SecondLevelAuthenticationDisplay {
    var publisher: AnyPublisher<SecondLevelAuthentication.Event, Never> {
        ensureMainThread((secondLevelAuthViewModel ?? createSecondLevelAuth()).publisher)
    }

    var eventHandler: PassthroughSubject<Result<Void, PinVerificationError>, Never> {
        ensureMainThread((secondLevelAuthViewModel ?? createSecondLevelAuth()).passthroughSubject)
    }

    private func ensureMainThread<T>(_ closure: @autoclosure () -> T) -> T {
        if Thread.isMainThread {
            return closure()
        } else {
            return DispatchQueue.main.sync { closure() }
        }
    }

    private func createSecondLevelAuth() -> SecondLevelAuthViewModel {
        let name = "SecondLevelAuth"
        let title = Strings.Localizable.loginPinScreenTitle
        let screen: PinPadScreen<SecondLevelAuthViewModel> = container.resolve()
        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .onAppDidEnterBackground {
                    Modals.pinPadOverlay.dismiss(name)
                }
                .addClose {
                    Modals.pinPadOverlay.dismiss(name)
                }
        )
        screen.viewModel.onFinish = {
            Modals.pinPadOverlay.dismiss(name)
        }
        screen.viewModel.onForceLogout = { [weak self] in
            self?.onForceLogout()
        }
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        let pinModal = UINavigationController(rootViewController: hostingController)
        pinModal.modalPresentationStyle = .fullScreen
        pinModal.modalTransitionStyle = .crossDissolve

        Modals.pinPadOverlay.show(viewController: pinModal, name: name)
        secondLevelAuthViewModel = screen.viewModel

        return screen.viewModel
    }
}
