//
//  MainCoordinator.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 16..
//

import Combine
import Resolver
import SwiftUI
import UIKit
import DesignKit

class MainCoordinator: Coordinator {
    @Injected var accountAction: AccountAction
    @Injected var userAction: UserAction
    @Injected var accountState: ReadOnly<Account?>
    @Injected var tokenState: ReadOnly<Token?>
    @Injected var individualState: ReadOnly<Individual?>
    @Injected var tempPinStore: any TemporaryPinStore
    @Injected var onboardingStateStore: any OnboardingStateStore
    @Injected var pinVerification: PinVerification
    @Injected var backgroundTimeObserver: BackgroundTimeObserver
    @Injected var foregroundActivityObserver: ForegroundActivityObserver
    @Injected var secondLevelAuth: SecondLevelAuthentication
    @Injected var pushSubscriptionWorker: PushSubscriptionWorker

    weak var secondLevelAuthViewModel: SecondLevelAuthViewModel?
    let tabBarController = TabBarController()

    let navigationController: UINavigationController = {
        let navigationController = BrandedNavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    override init(container: Resolver) {
        super.init(container: container)

        tokenState.publisher
            .compactMap { $0?.foregroundSessionExpired }
            .removeDuplicates()
            .filter { $0 == true }
            .sink { [weak self] _ in
                self?.showPinVerification(
                    renewSession: true,
                    title: Strings.Localizable.loginPinScreenTitle,
                    screenName: "",
                    then: { _ in }
                )
            }
            .store(in: &disposeBag)

        foregroundActivityObserver.onForegroundActivityWarning = { dismissHandler in
            let model: AlertModel = .foregroundWarning
            let alert = DesignAlertView(
                with: model,
                onActionSelected: { Modals.bottomInfo.dismiss(model.uuid) }
            ).onAppDidEnterBackground { Modals.bottomInfo.dismiss(model.uuid) }

            Modals.bottomInfo.show(
                view: alert,
                name: model.uuid,
                onClose: { dismissHandler() }
            )
        }

        secondLevelAuth.display = self
    }

    func start(on context: UIWindow?) {
        proceed()
        pinVerification.display = self
        context?.setRootViewController(navigationController, animated: true)
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { _, _ in }
        )
    }

    private func proceed() {
        let info = onboardingStateStore.state.value
        if let pinCode = tempPinStore.state.value, info.isBiometricAuthPromotionRequired {
            tempPinStore.modify {
                $0 = nil
            }
            startBiometrySetup(pinCode: pinCode)
        } else if info.isRegistrationSuccessScreenRequired {
            showFinishRegistration()
        } else {
            showTabs()
        }
    }

    private func showTabs() {
        let dashboard = makeDashboard()
        let transactions = makeTransactions()
        let contacts = makeContacts()

        tabBarController.viewControllers = [dashboard, transactions, contacts]
        tabBarController.navigationBarStyle = .hidden
        tabBarController.isSelectionDisabled = true
        navigationController.setViewControllersWithCrossfade([tabBarController])
        downloadRequiredData()
    }

    private func downloadRequiredData() {
        userAction.loadIndividual()
            .append(accountAction.refreshAccounts())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.onRequiredDataDownloaded()
                case .failure:
                    let name = "initial_loading_error"
                    let result = ResultModel.genericError(
                        screenName: name,
                        action: { [weak self] in
                            Modals.fullScreen.dismiss(name)
                            self?.downloadRequiredData()
                        })
                    Modals.fullScreen.show(view: ResultScreen(model: result), name: name)
                }
            })
            .store(in: &disposeBag)
    }

    private func onRequiredDataDownloaded() {
        if accountState.value == nil {
            startAccountOpening(then: { [weak self] in
                self?.tabBarController.isSelectionDisabled = false
            })
        } else {
            tabBarController.isSelectionDisabled = false
        }
    }

    private func startAccountOpening(then completion: @escaping () -> Void) {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: AccountOpeningAssembly()) { container in
                AccountOpeningCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(on: tabBarController) { [weak self, weak coordinator] in
            self?.tabBarController.dismiss(animated: true)
            guard let child = coordinator else { return }
            self?.remove(child: child)
            completion()
        }
    }

    private func makeDashboard() -> UIViewController {
        let dashboardCoordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: DashboardAssembly()) { container in
                DashboardCoordinator(container: container)
            }
        add(child: dashboardCoordinator)
        dashboardCoordinator.newTransferRequested = { [weak self] in
            self?.startNewTransfer()
        }
        let entryPoint = dashboardCoordinator.startingScreen()
        entryPoint.tabBarItem = Tab.dashboard.tabBarItem

        return entryPoint
    }

    private func makeTransactions() -> UIViewController {
        let transactionHistoryCoordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: PaymentTransactionHistoryAssembly()) { container in
                PaymentTransactionHistoryCoordinator(container: container)
            }
        add(child: transactionHistoryCoordinator)
        let entryPoint = transactionHistoryCoordinator.startingScreen()
        entryPoint.tabBarItem = Tab.transactionHistory.tabBarItem

        return entryPoint
    }

    private func makeContacts() -> UIViewController {
        let contactsTitle = Strings.Localizable.contactHeaderTitle
        let contactsScreen = container.resolve(ContactsScreen<ContactsScreenViewModel>.self)
        let contacts = UIHostingController(rootView: contactsScreen)
        contactsScreen.viewModel.screenListener = self
        contacts.title = contactsTitle
        contacts.tabBarItem = Tab.help.tabBarItem
        return BrandedNavigationController(rootViewController: contacts)
    }

    private func startBiometrySetup(pinCode: PinCode) {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: BiometrySetupAssembly()) { container in
                BiometrySetupCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(on: navigationController, pin: pinCode) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
            self.onboardingStateStore.modify {
                $0.isBiometricAuthPromotionRequired = false
            }
            self.proceed()
        }
    }

    private func startNewTransfer() {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: NewTransferAssembly()) { container in
                NewTransferCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(in: navigationController) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        }
    }

    private func showFinishRegistration() {
        let screen = ResultScreen(model: .registrationSuccess { [weak self] in
            self?.onFinishConfirmed()
        })
        let hostingController = UIHostingController(
            rootView: screen
                .navigationBarBackButtonHidden(true)
                .analyticsScreenView("registration_success")
        )
        hostingController.navigationItem.hidesBackButton = true
        navigationController.setViewControllersWithCrossfade([hostingController])
    }

    private func onFinishConfirmed() {
        onboardingStateStore.modify {
            $0.isRegistrationSuccessScreenRequired = false
        }
        proceed()
    }
}

extension MainCoordinator: ContactsScreenListener {
    func contactInfoScreenRequested() {
        let title = Strings.Localizable.featureInfoTitle
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.commonBetaInfoMarkdown) { [weak tabBarController] in
                tabBarController?.dismiss(animated: true, completion: nil)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView("feature_info")
            .addClose { [weak tabBarController] in
                tabBarController?.dismiss(animated: true, completion: nil)
            }

        let hosting = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        tabBarController.present(hosting, animated: true)
    }

    func feedbackRequested() {
        let title = Strings.Localizable.contactSendFeedback
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.testflightFeedbackReminder)
            .acknowledge(onAcknowledge: { [weak tabBarController] in
                tabBarController?.dismiss(animated: true, completion: nil)
            })
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView("testflight_feedback_reminder")
            .addClose { [weak tabBarController] in
                tabBarController?.dismiss(animated: true, completion: nil)
            }
        let host = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        tabBarController.present(host, animated: true)
    }
}

extension MainCoordinator {
    func onForceLogout() {
        let name = "ForceLogout"
        Modals.dismissAll()
        Modals.fullScreen.show(
            view: ResultScreen(model: .logoutForced { Modals.fullScreen.dismiss(name) }),
            name: name
        )
    }
}
