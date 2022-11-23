//
//  RegistrationCoordinator.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import Combine
import Foundation
import Resolver
import SwiftUI
import DesignKit

class RegistrationCoordinator: Coordinator {
    @Injected var onboardingStateStore: any OnboardingStateStore
    @Injected var pinStore: any TemporaryPinStore
    @Injected var draftStore: any RegistrationDraftStore
    @Injected var authKeyStore: any AuthenticationKeyStore
    @Injected var tokenStore: any TokenStore

    private let navigationController: UINavigationController = {
        let navigationController = BrandedNavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func start(on context: UIWindow?) {
        let welcome: RegistrationWelcomeScreen<RegistrationWelcomeScreenViewModel> = container.resolve()
        welcome.viewModel.events
            .sink { [weak self] event in
                switch event {
                case .startDeviceActivation:
                    self?.showDeviceActivationStart()
                case .startRegistration:
                    self?.showRegistration()
                }
            }
            .store(in: &disposeBag)
        navigationController.viewControllers = [UIHostingController(rootView: welcome)]
        context?.setRootViewController(navigationController, animated: true)
    }

    private func reset() {
        tokenStore.modify {
            $0 = nil
        }
        draftStore.modify {
            $0 = .init()
        }
        navigationController.popToRootViewController(animated: true)
    }

    private func finalize() {
        guard let userId = draftStore.state.value.phoneNumber,
              let keyFile = draftStore.state.value.keyFile else {
              fatalError("RegistrationCoordinator finalize, missing userId or keyFile")
        }
        authKeyStore.modify {
            $0 = .init(id: userId,
                       keyFile: keyFile)
        }
    }
}

// MARK: Navigation

extension RegistrationCoordinator {
    private func showHelp() {
        ActionSheetView(.contactsAndHelp).show()
    }

    private func showRegistration() {
        let title = Strings.Localizable.registrationStartScreenTitle
        let registrationStart: RegistrationStartScreen<RegistrationStartScreenViewModel> = container.resolve()
        registrationStart.viewModel.events
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .infoProvided(phoneNumber: let phoneNumber, email: let email):
                    self.draftStore.modify { draft in
                        if email != draft.email || phoneNumber != draft.phoneNumber {
                            draft.smsOtpInfo = nil
                        }
                        draft.phoneNumber = phoneNumber
                        draft.email = email
                        draft.isTermsAccepted = true
                        draft.isPrivacyAccepted = true
                    }
                    self.showCreatingPassword()
                case .termsAndConditionsRequested(url: let url):
                    self.showTermsAndConditions(url: url)
                case .privacyPolicyRequested(url: let url):
                    self.showPrivacyPolicy(url: url)
                case .phoneInfoRequested:
                    self.showPhoneInfoScreen()
                case .emailInfoRequested:
                    self.showEmailInfoScreen()
                }
            }
            .store(in: &disposeBag)

        let screen = registrationStart
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        let hostingController = UIHostingController(rootView: screen)
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)

        draftStore.modify {
            $0.flowKind = .registration
            $0.isPrivacyAccepted = false
            $0.isTermsAccepted = false
        }
    }

    private func showTermsAndConditions(url: String) {
        let title = Strings.Localizable.termsOfUseTitle
        let viewModel = SimpleDocumentViewerViewModel(
            source: .url(url),
            actionTitle: Strings.Localizable.commonAccept
        ) { [navigationController, draftStore] in
            draftStore.modify { $0.isTermsAccepted = true }
            navigationController.popViewController(animated: true)
        }
        let screen = DocumentViewerScreen(viewModel: viewModel)
            .analyticsScreenView("registration_terms")
            .navigationTitle(title)
        let host = UIHostingController(rootView: screen)
        host.title = title
        navigationController.pushViewController(host, animated: true)
    }

    private func showPrivacyPolicy(url: String) {
        let title = Strings.Localizable.privacyPolicyTitle
        let viewModel = SimpleDocumentViewerViewModel(
            source: .url(url),
            actionTitle: Strings.Localizable.commonAccept
        ) { [navigationController, draftStore] in
            draftStore.modify { $0.isPrivacyAccepted = true }
            navigationController.popViewController(animated: true)
        }
        let screen = DocumentViewerScreen(viewModel: viewModel)
            .navigationTitle(title)
            .analyticsScreenView("registration_privacy_policy")
        let host = UIHostingController(rootView: screen)
        host.title = title
        navigationController.pushViewController(host, animated: true)
    }

    private func showPhoneInfoScreen() {
        let title = Strings.Localizable.registrationPhoneInfoTitle
        let screen = InfoScreen(model: .registrationPhone { [weak navigationController] in
            navigationController?.dismiss(animated: true, completion: nil)
        })
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .addClose { [weak navigationController] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
        .analyticsScreenView("registration_add_phone_number_info")

        let hosting = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        navigationController.topViewController?.present(hosting, animated: true)
    }

    private func showEmailInfoScreen() {
        let title = Strings.Localizable.registrationEmailInfoTitle
        let screen = InfoScreen(model: .registrationEmail { [weak navigationController] in
            navigationController?.dismiss(animated: true, completion: nil)
        })
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .addClose { [weak navigationController] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
        .analyticsScreenView("registration_add_email_info")

        let hosting = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        navigationController.topViewController?.present(hosting, animated: true)
    }

    private func showDeviceActivationStart() {
        let title = Strings.Localizable.deviceActivationScreenTitle
        let activation: DeviceActivationStartScreen<DeviceActivationStartScreenViewModel> = container.resolve()
        activation.viewModel.events
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .helpRequested:
                    self.showHelp()
                case .deviceActivationStarted(phoneNumber: let phoneNumber):
                    self.draftStore.modify { draft in
                        draft.phoneNumber = phoneNumber
                    }
                    self.showRegistrationOTP()
                }
            }
            .store(in: &disposeBag)

        let screen = activation
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)

        let host = UIHostingController(rootView: screen)
        host.title = title
        host.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(host, animated: true)

        draftStore.modify {
            $0.flowKind = .deviceActivation
        }
    }

    private func showCreatingPassword() {
        let title = Strings.Localizable.createPasswordScreenTitle
        let createPassword: PasswordCreationScreen<PasswordCreationScreenViewModel> = container.resolve()
        createPassword.viewModel.events
            .sink { [weak self] event in
                switch event {
                case .passwordCreated:
                    self?.showRegistrationOTP()
                case .regNotAllowed:
                    self?.reset()
                case .regTemporaryBlocked:
                    self?.reset()
                }
            }
            .store(in: &disposeBag)
        let screen = createPassword
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)

        let hostingController = UIHostingController(rootView: screen)
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showRegistrationOTP() {
        let isRegistration = draftStore.state.value.flowKind == .registration
        let title = Strings.Localizable.registrationOtpScreenTitle
        let registrationOTP: RegistrationOTPScreen<RegistrationOTPScreenViewModel> = container.resolve()
        registrationOTP.viewModel.events
            .sink { [weak self] event in
                switch event {
                case .otpVerified:
                    self?.showOTPVerified()
                case .restartRegistrationRequested:
                    self?.reset()
                }
            }
            .store(in: &disposeBag)

        let screen = registrationOTP
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView(isRegistration ? "registration_otp" : "device_activation_otp")
        let hostingController = UIHostingController(rootView: screen)
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showOTPVerified() {
        let isRegistration = draftStore.state.value.flowKind == .registration
        let otpVerified = ResultScreen(
            model: .otpVerified { [weak self] in
                self?.showPinInfo()
            }
        )
        let screen = otpVerified
            .navigationBarBackButtonHidden(true)
            .analyticsScreenView(isRegistration ? "registration_otp_success" : "device_activation_otp_success")

        let hostingController = UIHostingController(rootView: screen)
        navigationController.pushWithCrossfade(hostingController)
    }

    private func showPinInfo() {
        let isRegistration = draftStore.state.value.flowKind == .registration

        let pinInfo: PinInfoScreen<PinInfoScreenViewModel> = container.resolve()
        pinInfo.viewModel.events
            .sink { [weak self] event in
                switch event {
                case .proceed:
                    self?.showPinCreation()
                case .hintRequested:
                    self?.showPinInfoHint()
                }
            }
            .store(in: &disposeBag)

        let screen = pinInfo
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView(isRegistration ? "registration_create_pin" : "device_activation_create_pin")

        let host = UIHostingController(rootView: screen)
        host.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushWithCrossfade(host)
    }

    private func showPinInfoHint() {
        let name = "pininfo"
        Modals.bottomInfo.show(
            view: PinCreationInfoDialog { Modals.bottomInfo.dismiss(name) },
            name: name
        )
    }

    private func showPinCreation() {
        let title = Strings.Localizable.pinChangeCreationScreenTitle
        let pinpad: PinPadScreen<PinCreationScreenViewModel> = container.resolve()
        pinpad.viewModel.events
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .finishedPinCreation(let pin):
                    self.pinStore.modify {
                        $0 = pin
                    }
                    let flowKind = self.draftStore.state.value.flowKind
                    self.onboardingStateStore.modify {
                        $0.isRegistrationSuccessScreenRequired = flowKind == .registration
                        $0.isBiometricAuthPromotionRequired = true
                    }
                    self.finalize()
                case .pinCreationTipsRequested:
                    self.showPinInfoHint()
                }
            }
            .store(in: &disposeBag)

        let screen = pinpad
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)

        let host = UIHostingController(rootView: screen)
        host.title = title
        host.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(host, animated: true)
    }
}
