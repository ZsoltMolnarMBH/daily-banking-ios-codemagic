//
//  DashboardCoordinator.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 12..
//

import DesignKit
import Resolver
import SwiftUI
import UIKit

// swiftlint:disable type_body_length
class DashboardCoordinator: Coordinator, TransactionDetailsDisplaying, MonthlyStatementDisplaying {
    var newTransferRequested: (() -> Void)?
    let navigationController: UINavigationController = {
        let navigationController = BrandedNavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func startingScreen() -> UIViewController {
        let dashboard: DashboardScreen = container.resolve()

        dashboard.viewModel.events.sink { [weak self] result in
            switch result {
            case .headerSelected:
                self?.showProfileScreen()
            case .newTransferRequested:
                self?.newTransferRequested?()
            case .accountDetailsRequested:
                self?.showAccountDetails()
            case .cardInfoRequested:
                self?.showCardInfo()
            case .recentTransactionSelected(let transaction):
                self?.showPaymentTransactionDetails(transaction)
            }
        }.store(in: &disposeBag)

        dashboard.scaChallengeVM.events.sink { [weak self] result in
            switch result {
            case .infoRequested:
                self?.showPaymentInfo()
            case .approved:
                let name = "approved"
                let result = ResultModel.challengeApproved { Modals.fullScreen.dismiss(name) }
                Modals.fullScreen.show(view: ResultScreen(model: result), name: name)
            case .declined:
                let name = "declined"
                let result = ResultModel.challengeDeclined { Modals.fullScreen.dismiss(name) }
                Modals.fullScreen.show(view: ResultScreen(model: result), name: name)
            }
        }.store(in: &disposeBag)

        dashboard.proxyId.events.sink { [weak self] result in
            switch result {
            case .proxyIdCreationRequested:
                self?.startProxyIdCreation()
            }
        }.store(in: &disposeBag)

        let screen = dashboard
            .navigationBarTitleDisplayMode(.inline)
        let hosting = UIHostingController(rootView: screen)
        hosting.navigationItem.largeTitleDisplayMode = .never
        navigationController.viewControllers = [hosting]
        return navigationController
    }

    private func showProfileScreen() {
        let title = Strings.Localizable.profileScreenTitle
        let profile: ProfileScreen<ProfileScreenViewModel> = container.resolve()
        profile.viewModel.events.sink { [weak self] result in
            switch result {
            case .personalInfoRequested:
                self?.showPersonalInfo()
            case .monthlyStatementsRequested:
                self?.showMonthlyStatements()
            case .contractsRequested:
                self?.showContracts()
            case .changeMPinRequested:
                self?.startPinChange()
            case .toggleBiometricAuthRequested:
                self?.presentBiometricAuth()
            }
        }.store(in: &disposeBag)

        let screen = profile
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)

        let hostingController = UIHostingController(rootView: screen)
        hostingController.title = title
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.navigationItem.largeTitleDisplayMode = .always
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showPersonalInfo() {
        let title = Strings.Localizable.personalDetailsTitle
        let personalInfo: PersonalInfoScreen<PersonalInfoScreenViewModel> = container.resolve()
        personalInfo.viewModel.events.sink { [weak self] result in
            switch result {
            case .personalDataEditingHelpRequested:
                self?.presentPersonalDataEditingHelp()
            }
        }.store(in: &disposeBag)

        let screen = personalInfo
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)

        let hostingController = UIHostingController(rootView: screen)
        hostingController.title = title
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.navigationItem.largeTitleDisplayMode = .always
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showMonthlyStatements() {
        let title = Strings.Localizable.monthlyStatementScreenTitle
        let screen: MonthlyStatementsScreen<MonthlyStatementsScreenViewModel> = container.resolve()
        screen.viewModel.events.sink { [weak self] result in
            switch result {
            case .statementSelected(let monthlyStatement):
                self?.showMonthlyStatement(monthlyStatement, analyticsName: "documents_monthly_statements")
            }
        }.store(in: &disposeBag)

        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showContracts() {
        let title = Strings.Localizable.contractsScreenTitle
        let screen: UserContractsScreen<UserContractsScreenViewModel> = container.resolve()
        screen.viewModel.events.sink { [weak self] result in
            switch result {
            case .contractSelected(let contract):
                self?.showDocument(
                    source: .contract(contract.contractID),
                    title: contract.title,
                    analyticsName: "account_closing_contracts_\(contract.title.asAnalyticsTitle)"
                )
            }
        }.store(in: &disposeBag)

        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showAccountDetails() {
        let title = Strings.Localizable.accountDetailsScreenTitle
        let screen: AccountDetailsScreen = container.resolve()
        screen.viewModel.events.sink { [weak self] result in
            switch result {
            case .accountDetailsExplanationRequested:
                self?.showAccountDetailsExplanation()
            case .limitedAccountInfoRequested:
                self?.showLmitedAccountInfo()
            case .proxyIdExplanationRequested:
                self?.showProxyIdExplanation()
            case .transactionLimitStartPageRequested:
                self?.showAccountDailyTransferLimitStartPage()
            case .packageDetailsRequested:
                self?.showPackageDetails()
            case .accountClosingFlowStartRequested:
                self?.startAccountClosingFlow()
            }
        }.store(in: &disposeBag)

        screen.proxyId.events.sink { [weak self] result in
            switch result {
            case .proxyIdCreationRequested:
                self?.startProxyIdCreation()
            }
        }.store(in: &disposeBag)

        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func startAccountClosingFlow() {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: AccountClosingAssembly()) { container in
                AccountClosingCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(on: navigationController) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        }
    }

    private func showAccountDetailsExplanation() {
        let title = Strings.Localizable.accountDetailsInfoScreenTitle
        let newModal = BrandedNavigationController()
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.accountDetailsInfoMarkdown) { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .analyticsScreenView("account_details_info")
                .addClose { [weak self] in
                    self?.navigationController.dismiss(animated: true)
                }
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        newModal.viewControllers = [hostingController]
        navigationController.present(newModal, animated: true)
    }

    private func showAccountDailyTransferLimitInfo() {
        let title = Strings.Localizable.accountTransactionLimitInfoTitle
        let newModal = BrandedNavigationController()
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.accountDailyLimitInfoMarkdown) { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .analyticsScreenView("account_limits_info")
                .navigationBarTitleDisplayMode(.inline)
                .addClose { [weak self] in
                    self?.navigationController.dismiss(animated: true)
                }
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        newModal.viewControllers = [hostingController]
        navigationController.present(newModal, animated: true)
    }

    private func showLmitedAccountInfo() {
        let title = Strings.Localizable.commonLimitedAccount
        let newModal = BrandedNavigationController()
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.accountDetailsLimitedAccountInfoMarkdown) { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .analyticsScreenView("limited_account_info")
                .addClose { [weak self] in
                    self?.navigationController.dismiss(animated: true)
                }
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        newModal.viewControllers = [hostingController]
        navigationController.present(newModal, animated: true)
    }

    private func showAccountDailyTransferLimitStartPage() {
        let title = Strings.Localizable.accountTransactionLimitStartPageTitle
        let screen: AccountLimitStartPageScreen<AccountLimitStartPageScreenViewModel> = container.resolve()
        screen.viewModel.events.sink { [weak self] result in
            switch result {
            case .limitScreenRequested:
                self?.showAccountDailyTransferLimit()
            case .limitInfoScreenRequested:
                self?.showAccountDailyTransferLimitInfo()
            }
        }.store(in: &disposeBag)

        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .analyticsScreenView("set_account_limits")
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showAccountDailyTransferLimit() {
        let title = Strings.Localizable.accountTransactionLimitDailyTransferTitle
        let screen: AccountDailyTransferLimitScreen<AccountDailyTransferLimitScreenViewModel> = container.resolve()
        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .analyticsScreenView("daily_transfer_limit")
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showCardInfo() {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: BankCardsAssembly()) { container in
                BankCardsCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(on: navigationController, onFinished: { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        })
    }

    private func showPaymentInfo() {
        let title = Strings.Localizable.purchaseChallengeTitle
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.purchaseChallengeInfoMarkdown)
            .acknowledge(onAcknowledge: { [weak navigationController] in
                navigationController?.dismiss(animated: true, completion: nil)
            })
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .addClose { [weak navigationController] in
                navigationController?.dismiss(animated: true, completion: nil)
            }
        let host = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        navigationController.present(host, animated: true)
    }

    func showProxyIdExplanation() {
        let title = Strings.Localizable.accountDetailsSecondaryIdInfoScreenTitle
        let newModal = BrandedNavigationController()
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.secondaryIdAboutMarkdown) { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .analyticsScreenView("secodary_id_info")
                .addClose { [weak self] in
                    self?.navigationController.dismiss(animated: true)
                }
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        newModal.viewControllers = [hostingController]
        navigationController.present(newModal, animated: true)
    }

    private func startPinChange() {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: PinChangeAssembly()) { container in
                PinChangeCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(on: navigationController, onFinish: { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        })
    }

    func startProxyIdCreation() {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: ProxyIdAssembly()) { container in
                ProxyIdCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(in: navigationController) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        }
    }

    private func showPaymentTransactionDetails(_ transaction: PaymentTransaction) {
        showTransactionDetails(of: transaction, on: navigationController, using: container)
    }

    private func showPackageDetails() {
        let coordinator = PackageDetailsCoordinator.new(parent: self)
        add(child: coordinator)
        let params = PackageDetailsCoordinator.Params(
            ctaTitle: Strings.Localizable.commonAllRight,
            visibleDocuments: [.conditionList],
            analyticsPrefix: "account_details",
            onProceed: { [weak self] in self?.navigationController.popViewController(animated: true) }
        )
        coordinator.start(on: navigationController, params: params) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        }
    }

    private func presentPersonalDataEditingHelp() {
        let screen = InfoScreen(model: .personalDataEditing {
            ActionSheetView(.contactsAndHelp).show()
        })
        .navigationBarTitleDisplayMode(.inline)
        .addClose { [weak navigationController] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
        .analyticsScreenView("personal_data_info")

        let hosting = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        navigationController.topViewController?.present(hosting, animated: true)
    }

    private func presentBiometricAuth() {
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: BiometrySetupAssembly()) { container in
                BiometrySetupCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.toggle(on: navigationController) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        }
    }
}
// swiftlint:enable type_body_length
