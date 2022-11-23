//
//  RegistrationDocumentViewerViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 30..
//

import DesignKit
import Foundation

class SimpleDocumentViewerViewModel: DocumentViewerScreenViewModelProtocol {
    let actionTitle: String?
    let showShareButton: Bool
    let source: DocumentSource?
    let isLoading = false
    let onAccept: (() -> Void)?
    let finished = false

    init(source: DocumentSource, actionTitle: String? = nil, showShareButton: Bool = false, onAccept: (() -> Void)? = nil) {
        self.source = source
        self.actionTitle = actionTitle
        self.showShareButton = showShareButton
        self.onAccept = onAccept
    }

    func handle(event: DocumentViweerScreenInput) {
        switch event {
        case .onAppear:
            break
        case .actionButtonPressed:
            onAccept?()
        }
    }
}
