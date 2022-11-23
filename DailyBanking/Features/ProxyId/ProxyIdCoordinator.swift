//
//  ProxyIdCreationCoordinator.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 11..
//

import Resolver
import SwiftUI
import Combine
import DesignKit

class ProxyIdCoordinator: Coordinator {
    @Injected private var account: ReadOnly<Account?>
    @Injected private var individual: ReadOnly<Individual?>
    @Injected private var draftStore: any ProxyIdDraftStore
    @Injected private var accountAction: AccountAction

    private weak var context: UIViewController?
    private lazy var navigationController = { () -> BrandedNavigationController in
        let navigatrionController = BrandedNavigationController()
        navigatrionController.modalPresentationStyle = .overFullScreen
        return navigatrionController
    }()
    private var onFinish: (() -> Void)?

    func start(in context: UIViewController, onFinish: @escaping () -> Void) {
        self.context = context
        self.onFinish = onFinish
        showTypeSelection()
    }

    private func finish() {
        onFinish?()
    }

    private func showTypeSelection() {
        guard let account = account.value,
              let individual = individual.value else { return }

        let actionSheet = ActionSheetView(.proxyIdTypeSelection(
            from: account,
            of: individual,
            onTypeSelected: { [weak self] kind, provisionedValue in
                self?.selected(kind: kind, provisionedValue: provisionedValue)
            }, onOtherSelected: { [weak self] in
                self?.showAddOtherProxyId()
            }
        ))

        actionSheet.show { [weak self] in
            self?.finish()
        }
    }

    private func selected(kind: ProxyId.Kind, provisionedValue: String?) {
        draftStore.modify {
            $0.kind = kind
            $0.value = provisionedValue
        }
        switch kind {
        case .emailAddress, .phoneNumber:
            showConfirmation()
        case .taxId:
            showAddTaxId()
        case .unknown:
            break
        }
    }

    private func showAddOtherProxyId() {
        guard let context = context else { return }
        modalUnavailableScreen(
            on: context,
            title: Strings.Localizable.accountDetailsSecondaryAccountCardAddButton,
            body: ProxyIdUnavailableFeature.other,
            screenViewName: "secondary_id_add_further_ids") { [weak self] in
                self?.finish()
            }
    }

    private func showAddTaxId() {
        guard let context = context else { return }
        modalUnavailableScreen(
            on: context,
            title: Strings.Localizable.secondaryIdTypeTaxnr,
            body: ProxyIdUnavailableFeature.taxId,
            screenViewName: "secondary_id_taxid") { [weak self] in
                self?.finish()
            }
    }

    private func showConfirmation() {
        guard let kind = draftStore.state.value.kind else {
            fatalError("Missing proxy id type before confirmation")
        }
        let title: String = Strings.Localizable.accountDetailsSecondaryIdAddTitle(kind.localized)
        let screenView: String
        switch kind {
        case .emailAddress:
            screenView = "secondary_id_email"
        case .phoneNumber:
            screenView = "secondary_id_mobile"
        default:
            fatalError("Unsupported proxy id type for confirmation")
        }
        let screen: ProxyIdConfirmationScreen<ProxyIdConfirmationScreenViewModel> = container.resolve()
        screen.viewModel.events.sink { [weak self, accountAction] result in
            switch result {
            case .privacyPolicyRequested:
                self?.showPrivacyPolicy()
            case .proxyIdCreated:
                self?.showSuccessScreen()
                accountAction.refreshAccounts().fireAndForget()
            }
        }.store(in: &disposeBag)

        let host = UIHostingController(rootView: screen
                                        .analyticsScreenView(screenView)
                                        .navigationTitle(title)
                                        .addClose { [weak self] in
            self?.context?.dismiss(animated: true)
            self?.finish()
        })
        host.title = title
        host.navigationItem.largeTitleDisplayMode = .never
        navigationController.viewControllers = [host]
        context!.present(navigationController, animated: true)
    }

    private func showPrivacyPolicy() {
        let title = Strings.Localizable.accountDetailsSecondaryIdPrivacyPolicyScreenTitle
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.secondaryIdPrivacyPolicyMarkdown, onAcknowledge: nil)
        let host = UIHostingController(rootView: screen
                                        .navigationTitle(title)
                                        .analyticsScreenView("secondary_id_privacy_policy_info"))
        host.title = title
        host.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(host, animated: true)
    }

    private func showSuccessScreen() {
        let screen = ResultScreen(model: .proxyIdCreationSuccess { [weak self] in
            self?.onSuccessAck()
        })
        let host = UIHostingController(rootView: screen
                                        .navigationBarBackButtonHidden(true)
                                        .analyticsScreenView("secondary_id_started"))
        navigationController.pushWithCrossfade(host)
    }

    private func onSuccessAck() {
        context?.dismiss(animated: true)
        finish()
    }
}
