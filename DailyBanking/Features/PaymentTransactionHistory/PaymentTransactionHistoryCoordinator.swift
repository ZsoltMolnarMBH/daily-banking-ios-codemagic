//
//  PaymentTransactionHistoryCoordinator.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 03..
//

import DesignKit
import Resolver
import SwiftUI
import UIKit

class PaymentTransactionHistoryCoordinator: Coordinator, TransactionDetailsDisplaying {
    var tabBarVisibilityCallback: ((Bool) -> Void)?

    let navigationController: UINavigationController = {
        let navigationController = BrandedNavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func startingScreen() -> UIViewController {
        let title = Strings.Localizable.transactionsTitle
        let screen = container.resolve(PaymentTransactionHistoryScreen<PaymentTransactionHistoryScreenViewModel>.self)
        screen.viewModel.listener = self

        let transactions = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        transactions.title = title
        transactions.navigationItem.largeTitleDisplayMode = .never
        navigationController.viewControllers = [transactions]
        return navigationController
    }
}

extension PaymentTransactionHistoryCoordinator: PaymentTransactionHistoryScreenListener {
    func onRecentTransactionSelected(_ transaction: PaymentTransaction) {
        showTransactionDetails(of: transaction, on: navigationController, using: container)
    }
}
