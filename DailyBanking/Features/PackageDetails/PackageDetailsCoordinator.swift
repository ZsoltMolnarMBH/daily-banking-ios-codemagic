//
//  PackageDetailsCoordinator.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 30..
//

import Foundation
import SwiftUI
import UIKit

extension PackageDetailsCoordinator {
    static func new(parent: Coordinator) -> PackageDetailsCoordinator {
        Coordinator.make(
            using: parent.container.makeChild(),
            assembly: PackageDetailsAssembly()) { container in
                PackageDetailsCoordinator(container: container)
            }
    }
}

class PackageDetailsCoordinator: Coordinator {
    struct Params {
        let ctaTitle: String
        let visibleDocuments: [LegalDocumentType]
        let analyticsPrefix: String
        let onProceed: (() -> Void)?
    }

    private var onFinished: (() -> Void)?
    private var params: Params!
    private weak var context: UINavigationController?

    func start(on context: UINavigationController, params: Params, onFinished: @escaping () -> Void) {
        self.context = context
        self.onFinished = onFinished
        self.params = params
        showPackageDetailsScreen()
    }

    private func showPackageDetailsScreen() {
        let title = Strings.Localizable.accountPackageDetailsTitle
        let packageDetailScreen = container.resolve(
            PackageDetailsScreen<PackageDetailsScreenViewModel>.self
        )
        packageDetailScreen.viewModel.actionButtonTitle = params.ctaTitle
        packageDetailScreen.viewModel.visibleDocuments = params.visibleDocuments
        packageDetailScreen.viewModel.screenListener = self
        packageDetailScreen.viewModel.onDeinit = { [weak self] in self?.onFinished?() }
        let screen = packageDetailScreen
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView("\(params.analyticsPrefix)_package_info")
        let hosting = UIHostingController(rootView: screen)
        hosting.title = title
        context?.pushViewController(hosting, animated: true)
    }
}

extension PackageDetailsCoordinator: PackageDetailsScreenListener {
    func onProceed() {
        params.onProceed?()
    }

    func accountOpeningPackageDetailsDocumentViewerRequested(title: String, url: String) {
        let screen = DocumentViewerScreen(
            viewModel: SimpleDocumentViewerViewModel(
                source: .url(url),
                actionTitle: Strings.Localizable.commonAllRight,
                showShareButton: true,
                onAccept: { [weak self] in
                    self?.context?.popViewController(animated: true)
                })
        )
        .navigationTitle(title)
        .analyticsScreenView("\(params.analyticsPrefix)_documents_\(title.asAnalyticsTitle)")

        let hosting = UIHostingController(rootView: screen.navigationTitle(title))
        hosting.title = title
        context?.pushViewController(hosting, animated: true)
    }
}
