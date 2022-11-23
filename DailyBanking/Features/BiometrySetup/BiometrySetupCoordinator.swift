//
//  BiometrySetupCoordinator.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 10..
//

import Combine
import DesignKit
import Foundation
import Resolver
import SwiftUI
import LocalAuthentication

class BiometrySetupCoordinator: Coordinator {
    @Injected var pinStore: BiometricAuthStore
    @Injected var analytics: ViewAnalyticsInterface
    @Injected var pinVerification: PinVerification

    private var onFinished: (() -> Void)?
    private weak var context: UINavigationController?
    private var authContext = LAContext.new

    /// Setup biometric authentication with education screens
    func start(on context: UINavigationController, pin: PinCode, onFinished: @escaping () -> Void) {
        self.context = context
        self.onFinished = onFinished

        switch authContext.biometryAvailability {
        case .permissionDenied, .notAvailable:
            onFinished()
        case .available, .disabledOSLevel, .biometryLocked:
            startBiometrySetup(pin: pin)
        }
    }

    private func startBiometrySetup(pin: PinCode) {
        let title = Strings.Localizable.biometrySetupHeaderTitle
        let setup = container.resolve(BiometrySetupScreen<BiometrySetupScreenViewModel>.self)
        setup.viewModel.pinCode = pin
        setup.viewModel.listener = self

        let hostingController = UIHostingController(
            rootView: setup
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
        )
        hostingController.navigationItem.hidesBackButton = true
        hostingController.navigationItem.largeTitleDisplayMode = .never
        hostingController.title = title
        context?.pushViewController(hostingController, animated: true)
    }

    private func showGeneralInfo(screenName: String) {
        let navigationController = BrandedNavigationController()
        let hosting = UIHostingController(
            rootView: BiometryInfoScreen(
                onClose: { [weak self] in
                    self?.context?.presentedViewController?.dismiss(animated: true)
                }).addClose { [weak self] in
                    self?.context?.presentedViewController?.dismiss(animated: true)
                }
                .analyticsScreenView(screenName)
        )
        navigationController.viewControllers = [hosting]
        context?.topViewController?.present(navigationController, animated: true)
    }

    private func showMultiBiometrucUsageHelp() {
        let screen = container.resolve(BiometryMultiUsageInfoScreen<BiometryMultiUsageInfoScreenViewModel>.self)
        screen.viewModel.onClose = { [weak self] in
            self?.context?.presentedViewController?.dismiss(animated: true)
        }
        let navigationController = BrandedNavigationController()
        let hosting = UIHostingController(
            rootView: screen
                .addClose { [weak self] in
                    self?.context?.presentedViewController?.dismiss(animated: true)
                }
        )
        navigationController.viewControllers = [hosting]
        context?.topViewController?.present(navigationController, animated: true)
    }

    /// Enable / Disable biometric Authentication
    func toggle(on context: UINavigationController, onFinished: @escaping () -> Void) {
        self.context = context
        self.onFinished = onFinished

        startBiometryToggle()
    }

    private func startBiometryToggle() {
        switch authContext.biometryAvailability {
        case .notAvailable:
            onFinished?()
        case .disabledOSLevel, .permissionDenied:
            showBiometryUnavailable()
        case .available:
            toggleBiometry()
        case .biometryLocked:
            showBiometryLocked()
        }
    }

    private func showBiometryLocked() {
        Modals.alert.show(alert: .biometryLockedAlert)
    }

    private func showBiometryUnavailable() {
        let title = Strings.Localizable.biometrySetupHeaderTitle
        let screen: BiometryUnavailableScreen<BiometryUnavailableScreenViewModel> = container.resolve()
        screen.viewModel.listener = self

        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )

        hostingController.navigationItem.largeTitleDisplayMode = .never
        hostingController.title = title
        context?.pushViewController(hostingController, animated: true)
    }

    private func toggleBiometry() {
        let screenViewName = authContext.biometryType == .faceID ? "profile_pin_faceid" : "profile_pin_touchid"
        Publishers.CombineLatest(
            pinVerification.verifyPin(screenName: screenViewName),
            pinStore.isPinCodeSaved.first().setFailureType(to: Error.self)
        ).flatMap { [pinStore] pinCode, isSaved in
            isSaved ? pinStore.delete() : pinStore.save(pinCode: pinCode)
        }
        .sink(receiveCompletion: { [authContext, analytics, weak self] completion in
            if case .finished = completion {
                let screenViewName = authContext.biometryType == .faceID ? "profile_faceid_success" : "profile_touchid_success"
                analytics.logScreenView(screenViewName)
            }
            self?.onFinished?()
        })
        .store(in: &disposeBag)
    }

    func settingsRequested() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension BiometrySetupCoordinator: BiometrySetupScreenListener {
    func skipRequested() {
        onFinished?()
    }

    func onBiometrySetupFinished() {
        onFinished?()
    }

    func generalHelpRequested() {
        showGeneralInfo(screenName: "biometric_general_info")
    }

    func multiBiometricUsageHelpRequested() {
        showMultiBiometrucUsageHelp()
    }
}

extension BiometrySetupCoordinator: BiometryUnavailableScreenListener {
    func helpRequested() {
        showGeneralInfo(screenName: "biometric_general_info")
    }

    func biometryBecameAvailable() {
        context?.popViewController(animated: false)
        toggleBiometry()
    }
}
