//
//  DocumentDisplaying.swift
//  DailyBanking
//
//  Created by ALi on 2022. 07. 29..
//

import Foundation
import UIKit
import SwiftUI

protocol DocumentDisplaying {
    var navigationController: UINavigationController { get }
}

extension DocumentDisplaying {

    func showDocument(source: DocumentSource, title: String, analyticsName: String) {
        let viewModel = SimpleDocumentViewerViewModel(source: source, showShareButton: true)
        let screen = DocumentViewerScreen<SimpleDocumentViewerViewModel>(viewModel: viewModel)
            .navigationTitle(title)
            .analyticsScreenView(analyticsName)
        let host = UIHostingController(rootView: screen)
        host.title = title
        navigationController.pushViewController(host, animated: true)
    }
}
