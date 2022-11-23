//
//  KycCoordinator.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 22..
//

import Foundation
import Resolver
import SwiftUI
import DesignKit

enum KycPageScreenEvent {
    case proceed
}

// swiftlint:disable:next type_body_length
class KycCoordinator: Coordinator {
    deinit {
        UIApplication.shared.isIdleTimerDisabled = false
    }

    enum Mode {
        case facekom
        case manual(email: String, phone: String)
    }

    enum Result {
        case finished(KycDraft)
        case cancelled
    }

    @Injected var draftStore: any KycDraftStore
    @Injected var nextStep: ReadOnly<FaceKom.Step>
    @Injected var faceKomAction: FaceKomAction
    @Injected var config: KycConfig
    @Injected var analytics: ViewAnalyticsInterface

    private(set) weak var context: UINavigationController?
    private var finish: ((Result) -> Void)?
    private var mode: Mode = .facekom

    private let navigationController: UINavigationController = {
        let navigationController = BrandedNavigationController()
        navigationController.viewControllers = []
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.overrideUserInterfaceStyle = .dark
        return navigationController
    }()

    func start(on context: UINavigationController, mode: Mode, onFinished: @escaping (Result) -> Void) {
        self.context = context
        self.finish = onFinished
        self.mode = mode
        switch mode {
        case .facekom:
            showStartScreen()
        case .manual(let email, let phone):
            var fields = FaceKom.DataConfirmationFields(from: [])
            fields.email = FaceKom.DataField(key: .email, value: email, isEditable: false, isRequired: true, regexp: nil)
            fields.phoneNumber = FaceKom.DataField(key: .phoneNumber, value: phone, isEditable: false, isRequired: true, regexp: nil)
            draftStore.modify {
                $0.fields = fields
            }
            showPersonalDataStep()
        }
    }

    private func showStartScreen() {
        let title = Strings.Localizable.kycStartPageScreenTitle
        let screen: KycStartScreen<KycStartScreenViewModel> = container.resolve()
        screen.viewModel.events
            .sink(receiveCompletion: { [weak self] _ in
                self?.faceKomAction.stop().fireAndForget()
                self?.finish?(.cancelled)
            }, receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showNextStep()
                case .helpRequested:
                    ActionSheetView(.contactsAndHelp).show()
                }
            })
            .store(in: &disposeBag)

        presentAsRoot(screen, title: title, analyticsName: "oao_ekyc_start")
    }

    private func presentAsRoot<T: View>(
        _ screen: T,
        title: String,
        analyticsName: String
    ) {
        let hosting = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .analyticsScreenView(analyticsName)
        )
        hosting.navigationItem.title = title
        hosting.navigationBarStyle = .inline

        if context?.viewControllers.count == 0 {
            context?.viewControllers = [hosting]
        } else {
            context?.pushViewController(hosting, animated: true)
        }
    }

    private func present<T: View>(
        _ screen: T,
        title: String,
        analyticsName: String,
        darkMode: Bool = true,
        keepScreenAwake: Bool = false
    ) {
        let host = UIHostingController(
            rootView: screen
                .addClose({ [weak self] in
                    self?.faceKomAction.stopVideo()
                    self?.context?.dismiss(animated: true, completion: { [weak self] in
                        self?.navigationController.viewControllers = []
                    })
                })
                .navigationTitle(title)
                .analyticsScreenView(analyticsName)
                .navigationBarBackButtonHidden(true)
                .onAppear { UIApplication.shared.isIdleTimerDisabled = keepScreenAwake }
                .environment(\.isSensitiveContent, config.safeDocumentPreviews)
        )
        host.title = title
        host.navigationItem.setHidesBackButton(true, animated: true)
        let currentStyle = UIScreen.main.traitCollection.userInterfaceStyle
        host.overrideUserInterfaceStyle = darkMode ? .dark : currentStyle
        navigationController.overrideUserInterfaceStyle = darkMode ? .dark : currentStyle
        if navigationController.viewControllers.count == 0 {
            navigationController.viewControllers = [host]
            context?.present(navigationController, animated: true)
        } else {
            navigationController.pushViewController(host, animated: true)
        }
    }

    private func showModal<T: View>(_ screen: T, title: String, analyticsName: String) {
        let host = UIHostingController(
            rootView: screen
                .addClose({ [weak self] in
                    self?.navigationController.dismiss(animated: true)
                })
                .navigationTitle(title)
                .analyticsScreenView(analyticsName)
        )
        host.title = title
        let nav = BrandedNavigationController(rootViewController: host)
        navigationController.present(nav, animated: true)
    }

    private func showSelfiePhotoScreen() {
        let title = Strings.Localizable.kycSelfieScreenTitle
        let screen = container.resolve(KycPhotoScreen<KycSelfiePhotoScreenViewModel>.self)
        screen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showNextStep()
                }
            })
            .store(in: &disposeBag)
        present(screen, title: title, analyticsName: "oao_ekyc_selfie_photo_start", keepScreenAwake: true)
    }

    private func showLivenessCheckScreen() {
        let title = Strings.Localizable.kycSelfieScreenTitle
        let screen = container.resolve(KycVideoScreen<KycLivenessCheckScreenViewModel>.self)
        screen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showNextStep()
                }
            })
            .store(in: &disposeBag)
        present(screen, title: title, analyticsName: "oao_ekyc_selfie_liveness_start", keepScreenAwake: true)
    }

    private func showIDInfoScreen(then handler: @escaping () -> Void) {
        let title = Strings.Localizable.commonDocuments
        let screen = IDInfoScreen(onAck: { handler() })
        present(screen, title: title, analyticsName: "oao_ekyc_prepare_id", keepScreenAwake: true)
    }

    private func showIDFrontScreen() {
        let title = Strings.Localizable.kycIdCardScreenTitle
        let screen = container.resolve(KycPhotoScreen<KycIDFrontScreenViewModel>.self)
        screen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showNextStep()
                }
            })
            .store(in: &disposeBag)
        present(screen, title: title, analyticsName: "oao_ekyc_id_front_start", keepScreenAwake: true)
    }

    private func showIDBackScreen() {
        let title = Strings.Localizable.kycIdCardScreenTitle
        let screen = container.resolve(KycPhotoScreen<KycIDBackScreenViewModel>.self)
        screen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showNextStep()
                }
            })
            .store(in: &disposeBag)
        present(screen, title: title, analyticsName: "oao_ekyc_id_back_start", keepScreenAwake: true)
    }

    private func showHologramScreen() {
        let title = Strings.Localizable.kycHologramScreenTitle
        let screen = container.resolve(KycVideoScreen<KycHologramScreenViewModel>.self)
        screen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showNextStep()
                }
            })
            .store(in: &disposeBag)
        present(screen, title: title, analyticsName: "oao_ekyc_id_hologram_start", keepScreenAwake: true)
    }

    private func showProofOfAddressPhotoScreen() {
        let title = Strings.Localizable.proofOfAddressDocument
        let screen = container.resolve(KycPhotoScreen<KycProofOfAddressScreenViewModel>.self)
        screen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showNextStep()
                }
            })
            .store(in: &disposeBag)
        present(screen, title: title, analyticsName: "oao_ekyc_address_card_start", keepScreenAwake: true)
    }

    private func showEIDReader() {
        let title = Strings.Localizable.kycEidScreenTitle
        let screen = container.resolve(ElectronicIDReaderScreen<ElectronicIDReaderScreenViewModel>.self)
        screen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .infoRequested:
                    let screen = ElectronicIDInfoScreen(onAck: { [weak self] in
                        self?.navigationController.dismiss(animated: true)
                    }).preferredColorScheme(.light)
                    self?.showModal(
                        screen, title: Strings.Localizable.kycEidInfoTitle,
                        analyticsName: "oao_ekyc_id_nfc_scan_info_general"
                    )

                case .nfcPositionInfoRequested:
                    let screen = NFCPositionInfoScreen(onAck: { [weak self] in
                        self?.navigationController.dismiss(animated: true)
                    })
                    self?.showModal(
                        screen, title: Strings.Localizable.kycEidInfoTitle,
                        analyticsName: "oao_ekyc_id_nfc_scan_info_device"
                    )
                case .nfcReadingFinished:
                    self?.showNextStep()
                }
            })
            .store(in: &disposeBag)
        present(screen, title: title, analyticsName: "oao_ekyc_id_nfc_scan", darkMode: false)
    }

    private func showNextStep() {
        draftStore.modify {
            $0.stepMessage = nil
            $0.stepProgress = nil
        }

        switch nextStep.value {
        case .undetermined:
            break
        case .customerPortrait:
            showSelfiePhotoScreen()
        case .livenessCheck:
            showLivenessCheckScreen()
        case .idFront:
            showIDInfoScreen(then: { [weak self] in
                self?.showIDFrontScreen()
            })
        case .idBack:
            showIDBackScreen()
        case .hologram:
            showHologramScreen()
        case .proofOfAddress:
            showProofOfAddressPhotoScreen()
        case .eMRTD:
            showEIDReader()
        case .dataConfirmation(items: let items):
            analytics.logScreenView("oao_ekyc_success")
            let fields = FaceKom.DataConfirmationFields(from: items)
            draftStore.modify {
                $0.fields = fields
            }
            if config.autoCloseRoom { faceKomAction.stop().fireAndForget() }
            showPersonalDataStep()
        case .end(let status, _):
            // Flow ended, finished, aborted, failed (Example: the customer run out of retries at a certain step in the workflow), expired
            // Temporary solution
            guard status == "failed" else { return }
            context?.dismiss(animated: true, completion: { [weak self] in
                self?.navigationController.viewControllers = []
            })

        case .unknown(let rawValue):
            fatalError("Uknown step arrived in Kyc Flow -> \(rawValue)")
        }
    }

    private func showPersonalDataStep() {
        let title = Strings.Localizable.accountSetupMainPageTitle
        let personalDataScreen = container.resolve(PersonalDataStartScreen<PersonalDataStartScreenViewModel>.self)
        let navController: UINavigationController?
        if case .facekom = mode {
            navController = navigationController
        } else {
            navController = context
        }
        personalDataScreen.viewModel.events
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .contactsRequested:
                    self?.showContactsScreen(on: navController)
                case .addressRequested:
                    self?.showAddressScreen(on: navController)
                case .documentsRequested:
                    self?.showDocumentsScreen(on: navController)
                case .personalDataRequested:
                    self?.showPersonalDataScreen(on: navController)
                case .contactsInfoRequested:
                    self?.showContactsInfo()
                case .dataValidated:
                    self?.onAccountDataValidated()
                }
            })
            .store(in: &disposeBag)
        let screen = personalDataScreen
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)

        if case .facekom = mode {
            present(screen, title: title, analyticsName: "oao_progress_data", darkMode: false)
        } else {
            presentAsRoot(screen, title: title, analyticsName: "oao_progress_data")
        }
    }

    private func showContactsScreen(on navigationController: UINavigationController?) {
        let title = Strings.Localizable.accountSetupContactsTitle
        let contactsScreen = container.resolve(PersonalDataContactsScreen<PersonalDataContactsScreenViewModel>.self)
        let viewController = UIHostingController(rootView: contactsScreen.navigationTitle(title))
        viewController.title = title
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showPersonalDataScreen(on navigationController: UINavigationController?) {
        let title = Strings.Localizable.accountSetupPersonalDataTitle
        let personalDataScreen = container.resolve(PersonalDataPersonalDataScreen<PersonalDataPersonalDataScreenViewModel>.self)
        let viewController = UIHostingController(rootView: personalDataScreen.navigationTitle(title))
        viewController.title = title
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showAddressScreen(on navigationController: UINavigationController?) {
        let title = Strings.Localizable.accountSetupAddressTitle
        let addressScreen = container.resolve(PersonalDataAddressScreen<PersonalDataAddressScreenViewModel>.self)
        let viewController = UIHostingController(rootView: addressScreen.navigationTitle(title))
        viewController.title = title
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showDocumentsScreen(on navigationController: UINavigationController?) {
        let title = Strings.Localizable.accountSetupDocumentsTitle
        let documentsScreen = container.resolve(PersonalDataDocumentsScreen<PersonalDataDocumentsScreenViewModel>.self)
        let viewController = UIHostingController(rootView: documentsScreen.navigationTitle(title))
        viewController.title = title
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showContactsInfo() {
        ActionSheetView(.contactsAndHelp).show()
    }

    private func onAccountDataValidated() {
        faceKomAction.stop().fireAndForget()
        if case .facekom = mode {
            context?.dismiss(animated: true, completion: { [weak self] in
                self?.navigationController.viewControllers = []
            })
        }
        finish?(.finished(draftStore.state.value))
    }
}
