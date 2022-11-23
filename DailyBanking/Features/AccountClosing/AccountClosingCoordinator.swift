//
//  AccountClosingCoordinator.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 18..
//

import UIKit
import DesignKit
import Resolver
import SwiftUI

class AccountClosingCoordinator: Coordinator, DocumentDisplaying, MonthlyStatementDisplaying {

    @Injected var draftStore: any AccountClosingDraftStore
    @Injected var displayStrings: AccountClosingDisplayStringFactory

    private var onFinished: () -> Void = { }
    let navigationController: UINavigationController = {
        let navigationController = BrandedNavigationController()
        navigationController.viewControllers = []
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func start(on viewController: UIViewController, onFinished: @escaping () -> Void) {
        self.onFinished = onFinished

        Modals.bottomAlert.show(
            alert: .init(
                title: Strings.Localizable.accountClosingStartConfirmationTitle,
                imageName: ImageName.warningSemantic,
                subtitle: Strings.Localizable.accountClosingStartConfirmationText,
                actions: [
                    .init(title: Strings.Localizable.commonCancel, kind: .secondary) { [onFinished] in
                        onFinished()
                    },
                    .init(title: Strings.Localizable.commonYes,
                          kind: .primary
                         ) { [weak self] in
                             self?.startAccountClosingFlow(on: viewController)
                         }
                ])
        )
    }

    private func startAccountClosingFlow(on viewController: UIViewController) {
        let title = Strings.Localizable.accountClosingTitle

        let reasonScreen = container.resolve(
            AccountClosingReasonScreen<AccountClosingReasonScreenViewModel>.self
        )

        let documentsScreen = container.resolve(
            AccountClosingDocumentsScreen<AccountClosingDocumentsScreenViewModel>.self
        )
        documentsScreen.viewModel.events.sink { [weak self] result in
            switch result {
            case .contractsRequested:
                self?.showUserContractsScreen()
            case .monthlyStatementsRequested:
                self?.showMonthlyStatementsScreen()
            }
        }.store(in: &disposeBag)

        let transferScreen = container.resolve(
            AccountClosingTransferScreen<AccountClosingTransferScreenViewModel>.self
        )

        let signScreen = container.resolve(
            AccountClosingSignScreen<AccountClosingSignScreenViewModel>.self
        )
        signScreen.viewModel.events.sink { [weak self] result in
            switch result {
            case .accountClosingStatementRequested(let contractId):
                self?.showAccountClosingStatementViewer(contractId: contractId)
            }
        }.store(in: &disposeBag)

        let pager = PagerView(pages: [
            .init(id: UUID().uuidString, content: AnyView(reasonScreen)),
            .init(id: UUID().uuidString, content: AnyView(documentsScreen)),
            .init(id: UUID().uuidString, content: AnyView(transferScreen)),
            .init(id: UUID().uuidString, content: AnyView(signScreen))
        ])

        pager.controller.pageDidAppear = { page in
            if page == 0 {
                pager.analytics.logScreenView("account_closing_survey_step1")
            } else if page == 1 {
                pager.analytics.logScreenView("account_closing_documents_step2")
            } else if page == 2 {
                pager.analytics.logScreenView("account_closing_target_account_number_step3")
            } else if page == 3 {
                pager.analytics.logScreenView("account_closing_open_withdrawal_statement_step4")
            }
        }

        reasonScreen.viewModel.onGoNext = { [draftStore] reason, comment in
            draftStore.modify { draft in
                draft.reason = reason
                draft.comment = comment
            }
            pager.select(page: 1)
        }

        documentsScreen.viewModel.onGoBack = {
            pager.select(page: 0)
        }

        documentsScreen.viewModel.onGoNext = {
            pager.select(page: 2)
        }

        transferScreen.viewModel.onGoBack = {
            pager.select(page: 1)
        }

        transferScreen.viewModel.onGoNext = { [draftStore] transferAccount in
            draftStore.modify { draft in
                draft.transferAccount = transferAccount
            }
            pager.select(page: 3)
        }

        signScreen.viewModel.onGoBack = {
            pager.select(page: 2)
        }

        let screen = pager
            .showProgressBar(false)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .addClose { [weak self] in
                self?.navigationController.dismiss(animated: true)
                self?.onFinished()
                Modals.toast.show(text: Strings.Localizable.accountClosingCancelledToast)
            }

        let hosting = UIHostingController(rootView: screen)
        hosting.title = title
        navigationController.viewControllers = [hosting]
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }

    private func showMonthlyStatementsScreen() {
        let title = Strings.Localizable.monthlyStatementScreenTitle
        let screen: MonthlyStatementsScreen<MonthlyStatementsScreenViewModel> = container.resolve()
        screen.viewModel.events.sink { [weak self] result in
            switch result {
            case .statementSelected(let monthlyStatement):
                self?.showMonthlyStatement(monthlyStatement, analyticsName: "account_closing_statements")
            }
        }.store(in: &disposeBag)

        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .analyticsScreenView("account_closing_statements")
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showUserContractsScreen() {
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
                .analyticsScreenView("account_closing_contracts")
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    private func showAccountClosingStatementViewer(contractId: String) {
        let title = displayStrings.statementViewerTitle
        var viewModel: AccountClosingStatementViewerViewModel!
        container.useContext {
            viewModel = AccountClosingStatementViewerViewModel(
                closingDocument: .contract(contractId)
            )
        }
        viewModel.events.sink { [weak self] result in
            switch result {
            case .accountClosingFlowDone:
                self?.navigationController.dismiss(animated: true)
                self?.onFinished()
            }
        }.store(in: &disposeBag)

        let screen = DocumentViewerScreen<AccountClosingStatementViewerViewModel>(viewModel: viewModel)
            .mustReadThrough(true)
            .navigationTitle(title)
            .analyticsScreenView("account_closing_sign_withdrawal_statement_step5_withdrawal_document")
        let host = UIHostingController(rootView: screen)
        host.title = title
        navigationController.pushViewController(host, animated: true)
    }
}
