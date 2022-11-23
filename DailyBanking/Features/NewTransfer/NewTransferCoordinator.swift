//
//  NewTransferCoordinator.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 25..
//

import Resolver
import UIKit
import SwiftUI
import Combine

class NewTransferCoordinator: Coordinator {
    @Injected private var accountAction: AccountAction
    @Injected private var action: NewTransferAction
    @Injected private var paymentTransactionAction: PaymentTransactionAction
    @Injected private var draft: any NewTransferDraftStore
    @Injected private var account: ReadOnly<Account?>
    private var launchScreen: UIViewController!
    private var navigationController: UINavigationController?
    private var completion: (() -> Void)?

    enum Result {
        case complete
        case cancel
    }

    func start(in context: UINavigationController, completion: @escaping () -> Void) {
        self.completion = completion
        navigationController = context
        launchScreen = context.topViewController!
        showBeneficiaryScreen()

        action.updateDailyLimit()
            .retry(times: 10, delay: 5, when: { _ in true })
            .sink { _ in }
            .store(in: &disposeBag)
    }

    private func finish(with result: Result) {
        switch result {
        case .complete:
            navigationController?.popWithCrossfade(to: launchScreen)
        case .cancel:
            break
        }
        completion?()
        completion = nil
    }

    private func showBeneficiaryScreen() {
        let title = Strings.Localizable.newTransferBeneficiaryTitle
        let screen: BeneficiaryScreen<BeneficiaryScreenViewModel> = container.resolve()
        screen.viewModel.events
            .sink { [weak self] _ in
                self?.finish(with: .cancel)
            } receiveValue: { [weak self] result in
                self?.draft.modify {
                    $0.beneficiary = .init(name: result.benificaryName, accountNumber: result.accountNumber)
                    $0.notice = result.notice
                }
                self?.showAmountScreen()
            }
            .store(in: &disposeBag)
        let host = UIHostingController(rootView: screen
                                        .navigationTitle(title))
        host.title = title
        host.hidesBottomBarWhenPushed = true
        host.navigationBarStyle = .inline
        navigationController?.pushViewController(host, animated: true)
    }

    private func showAmountScreen() {
        let title = Strings.Localizable.newTransferAmountTitle
        let screen: AmountScreen<AmountScreenViewModel> = container.resolve()
        screen.viewModel.events
            .sink { [weak self] money in
                self?.draft.modify {
                    $0.money = money
                }
                self?.showSummaryScreen()
            }
            .store(in: &disposeBag)
        let host = UIHostingController(rootView: screen
                                        .navigationTitle(title))
        host.title = title
        navigationController?.pushViewController(host, animated: true)
    }

    private func showSummaryScreen() {
        let title = Strings.Localizable.newTransferSummaryTitle
        let screen: NewTransferSummaryScreen<NewTransferSummaryScreenViewModel> = container.resolve()
        screen.viewModel.events
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .transferFinished(let result):
                    self.accountAction.refreshAccounts().fireAndForget()
                    if let account = self.account.value {
                        self.paymentTransactionAction.refreshPaymentTransactions(of: account).fireAndForget()
                    }
                    switch result {
                    case .success(let success):
                        self.showResult(success: success)
                    case .failure(let error):
                        self.showResult(error: error)
                    }
                case .transferDateInfoRequested:
                    self.showTransferDateInfoScreen()
                }
            }
            .store(in: &disposeBag)
        let host = UIHostingController(rootView: screen
                                        .navigationTitle(title))
        host.title = title
        navigationController?.pushViewController(host, animated: true)
    }

    private func showResult(success: NewTransferSuccess) {
        if let transaction = success.transaction {
            let screen: NewTransferSuccessScreen<NewTransferSuccessScreenViewModel> = container.resolve(args: transaction)
            screen.viewModel.events
                .sink { [weak self] result in
                    switch result {
                    case .acknowledge:
                        self?.finish(with: .complete)
                    }
                }
                .store(in: &disposeBag)

            let screenView: String
            switch transaction.state {
            case .pending:
                screenView = "new_transfer_in_progress"
            case .completed:
                screenView = "new_transfer_success"
            case .rejected:
                screenView = ""
            }
            let host = UIHostingController(rootView: screen
                                            .navigationBarBackButtonHidden(true)
                                            .analyticsScreenView(screenView)
                                            .feedbackOnAppear(.success))
            navigationController?.pushWithCrossfade(host)
        } else {
            let screen = ResultScreen(model: .newTransferPendingNoInfo { [weak self] in
                    self?.finish(with: .complete)
                })
            let host = UIHostingController(rootView: screen
                                            .feedbackOnAppear(.success)
                                            .navigationBarBackButtonHidden(true))
            navigationController?.pushWithCrossfade(host)
        }
    }

    private func showResult(error: NewTransferError) {
        let screen = ResultScreen(model: .newTransferFailure(error: error, action: { [weak self] in
            self?.finish(with: .complete)
        }))
        let host = UIHostingController(rootView: screen
                                        .feedbackOnAppear(.success, after: .transition)
                                        .navigationBarBackButtonHidden(true))
        navigationController?.pushWithCrossfade(host)
    }

    private func showTransferDateInfoScreen() {
        let title = ""
        let screen = InfoScreen(model: .transferDate { [weak navigationController] in
            navigationController?.dismiss(animated: true)
        })
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .addClose { [weak navigationController] in
            navigationController?.dismiss(animated: true, completion: nil)
        }
        .analyticsScreenView("new_transfer_change_date_info")

        let hosting = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        navigationController?.topViewController?.present(hosting, animated: true)
    }
}
