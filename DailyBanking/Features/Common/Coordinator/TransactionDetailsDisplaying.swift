//
//  TransactionDetailsPresenter.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 02..
//

import UIKit
import Resolver
import SwiftUI

protocol TransactionDetailsDisplaying {}

extension TransactionDetailsDisplaying {
    func showTransactionDetails(of transaction: PaymentTransaction, on navigationController: UINavigationController, using container: Resolver) {
        let title = Strings.Localizable.transactionDetailsTitle
        let screen = container.resolve(PaymentTransactionDetailsScreen<PaymentTransactionDetailsScreenViewModel>.self)
        screen.viewModel.transaction = transaction

        let hostingController = UIHostingController(
            rootView: screen.navigationTitle(title)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )

        hostingController.title = title
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }
}
