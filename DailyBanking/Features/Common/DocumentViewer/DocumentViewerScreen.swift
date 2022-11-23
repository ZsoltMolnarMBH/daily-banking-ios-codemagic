//
//  DocumentViewerScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 30..
//

import SwiftUI
import DesignKit
import PDFKit

protocol DocumentViewerScreenViewModelProtocol: ObservableObject {
    var actionTitle: String? { get }
    var showShareButton: Bool { get }
    var source: DocumentSource? { get }
    var isLoading: Bool { get }
    var finished: Bool { get }
    var error: ResultModel? { get }

    func handle(event: DocumentViweerScreenInput)
}

extension DocumentViewerScreenViewModelProtocol {
    var error: ResultModel? { nil }
}

enum DocumentViweerScreenInput {
    case onAppear
    case actionButtonPressed
}

struct DocumentViewerScreen<ViewModel: DocumentViewerScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @StateObject var documentLoader = DocumentLoader()
    @State var showActivityView = false
    @State var isScrolledToBottom = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.keyWindowSafeAreaInsets) var safeArea

    var isScrollingToBottomRequired = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                switch documentLoader.state {
                case .idle, .loadFailed:
                    EmptyView()
                case .loading:
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .highlight.primary.background))
                            .scaleEffect(1.3)
                        Spacer()
                    }
                case .loaded(let document):
                    PDFKitView(
                        document,
                        singlePage: false,
                        isScrolledToBottom: $isScrolledToBottom
                    )
                }
                Spacer()
                if let actionTitle = viewModel.actionTitle {
                    Group {
                        DesignButton(
                            style: .primary,
                            title: actionTitle,
                            action: { viewModel.handle(event: .actionButtonPressed) }
                        )
                        .disabled(isButtonDisabled)

                        if isTextVisible {
                            Text(Strings.Localizable.documentMustReadThrough)
                                .textStyle(.body2)
                                .foregroundColor(Color.text.secondary)
                                .padding(.top, .m)
                        }
                    }
                    .padding(.horizontal, .m)
                    .padding([.bottom], safeArea.bottom > 0 ? 0 : .m)
                }
            }
            .animation(.default, value: isTextVisible)
            .animation(.default, value: isButtonDisabled)
        }
        .background(Color.background.secondary)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButtonView
            }
        })
        .onAppear {
            viewModel.handle(event: .onAppear)
        }
        .onChange(of: viewModel.finished) { isFinish in
            guard isFinish else { return }
            dismiss()
        }
        .onChange(of: viewModel.source) { source in
            documentLoader.load(from: source)
        }
        .onAppear {
            documentLoader.load(from: viewModel.source)
        }
        .sheet(isPresented: $showActivityView) {
            if let pdfData = documentLoader.pdfData {
                ActivityView(activityItems: [pdfData])
            }
        }
        .animation(.default, value: documentLoader.state.isLoaded)
        .fullscreenResult(model: viewModel.error, shouldHideNavbar: false)
        .fullscreenResult(model: documentLoader.state.error, shouldHideNavbar: false)
        .fullScreenProgress(by: viewModel.isLoading, name: "documentviewer")
    }

	var shareButtonView: some View {
        HStack {
            if viewModel.showShareButton {
                DesignButton(
                    style: .tertiary,
                    width: .fluid,
                    imageName: DesignKit.ImageName.share,
                    action: { showActivityView.toggle() }
                )
                .analyticsOverride(contentType: "share icon")
                .disabled(!documentLoader.state.isLoaded)
            }
        }
	}

    var isButtonDisabled: Bool {
        isTextVisible || !documentLoader.state.isLoaded
    }

    var isTextVisible: Bool {
        isScrollingToBottomRequired && !isScrolledToBottom
    }

    func mustReadThrough(_ value: Bool) -> DocumentViewerScreen {
        var view = self
        view.isScrollingToBottomRequired = value
        return view
    }
}

struct DocumentVieverScreenPreview: PreviewProvider {
    static var previews: some View {
        DocumentViewerScreen(viewModel: MockViewModel())
            .mustReadThrough(true)
            .preferredColorScheme(.light)
    }
}

private class MockViewModel: DocumentViewerScreenViewModelProtocol {
    var actionTitle: String? = "Szerződés aláírása"
    var showShareButton: Bool = true
    var source: DocumentSource? = .url("https://ms-onboarding.dev.sandbox-mbh.net/static/PSZSZ.pdf")
    var isLoading: Bool = false
    var finished: Bool = false

    func handle(event: DocumentViweerScreenInput) {}
}
