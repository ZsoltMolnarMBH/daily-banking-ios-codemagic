//
//  PackageDetailsScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 29..
//

import Foundation

protocol PackageDetailsScreenListener: AnyObject {
    func onProceed()
    func accountOpeningPackageDetailsDocumentViewerRequested(title: String, url: String)
}

class PackageDetailsScreenViewModel: PackageDetailsScreenViewModelProtocol {
    var actionButtonTitle: String = Strings.Localizable.commonNext
    var visibleDocuments = [LegalDocumentType]()
    weak var screenListener: PackageDetailsScreenListener?
    var onDeinit: (() -> Void)?

    deinit {
        onDeinit?()
    }

    func handle(_ event: PackageDetailsScreenInput) {
        switch event {
        case .actionButtonPressed:
            screenListener?.onProceed()
        case .documentPressed(let documentType):
            screenListener?.accountOpeningPackageDetailsDocumentViewerRequested(
                title: documentType.title,
                url: documentType.url
            )
        }
    }
}
