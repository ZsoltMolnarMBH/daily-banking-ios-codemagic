//
//  PDFKitView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 12. 08..
//

import Combine
import PDFKit
import SwiftUI

public struct PDFKitView: UIViewRepresentable {

    public class PDFPageObserver {
        private var disposeBag = Set<AnyCancellable>()
        private var onScrolledToBottom: () -> Void

        init(onScrolledToBottom: @escaping () -> Void) {
            self.onScrolledToBottom = onScrolledToBottom
        }

        func startObserving() {
            disposeBag.removeAll()
            NotificationCenter.default
                .publisher(for: .PDFViewPageChanged)
                .sink { [weak self] notification in
                    if let pdfView = notification.object as? PDFView,
                        let document = pdfView.document,
                        let currentPage = pdfView.currentPage {
                        let pageCount = document.pageCount
                        let currentPage = document.index(for: currentPage) + 1
                        if pageCount == currentPage { self?.onScrolledToBottom() }
                    }
                }
                .store(in: &disposeBag)
        }
    }

    public typealias UIViewType = PDFView
    @Binding var isScrolledToBottom: Bool
    let pdfView = PDFView()
    let document: PDFDocument?
    let singlePage: Bool

    public init(_ document: PDFDocument?, singlePage: Bool = false, isScrolledToBottom: Binding<Bool> = .constant(false)) {
        self.document = document
        self.singlePage = singlePage
        self._isScrolledToBottom = isScrolledToBottom
    }

    public func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> UIViewType {
        pdfView.autoScales = true
        pdfView.backgroundColor = .clear
        pdfView.pageShadowsEnabled = false
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        pdfView.document = document
        context.coordinator.startObserving()

        return pdfView
    }

    public func makeCoordinator() -> PDFPageObserver {
        PDFPageObserver {
            DispatchQueue.main.async {
                isScrolledToBottom = true
            }
        }
    }

    public func updateUIView(_ pdfView: UIViewType, context: UIViewRepresentableContext<PDFKitView>) {
        pdfView.document = document
        context.coordinator.startObserving()
    }
}
