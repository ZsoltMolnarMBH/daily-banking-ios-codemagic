//
//  PagerView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 05. 23..
//

import SwiftUI

public struct PagerView: View {
    public struct Page: Identifiable {
        public let id: String
        public let content: AnyView

        public init(id: String, content: AnyView) {
            self.id = id
            self.content = content
        }
    }

    public class Controller: ObservableObject {
        enum Direction {
            case left, right
        }

        @Published var selectedPage = 0
        @Published var coverVisible = false
        @Published var direction: Direction = .left

        public var pageDidAppear: ((Int) -> Void)?

        public init() {}

        public func select(page: Int) {
            direction = selectedPage < page ? .left : .right
            coverVisible = true
            selectedPage = page
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.coverVisible = false
            }
        }
    }

    @ObservedObject private (set) public var controller: Controller
    private let pages: [Page]
    private var isProgressVisible = false

    public init(controller: Controller = Controller(), pages: [Page]) {
        self.controller = controller
        self.pages = pages
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if isProgressVisible {
                    LinearProgressView(
                        steps: pages.count,
                        currentStep: $controller.selectedPage
                    )
                    .padding(.bottom, .s)
                    .padding(.horizontal, .l)
                }

                pages[controller.selectedPage].content
                    .onAppear {
                        controller.pageDidAppear?(controller.selectedPage)
                    }
                    .id(pages[controller.selectedPage].id)
                    .transition(controller.direction == .left ? .pageLeft : .pageRight)
            }
            VStack {
                if controller.coverVisible {
                    Color.clear
                        .background(Color.background.secondary)
                        .frame(height: 1)
                }
                Spacer()
            }
            .transaction { $0.animation = nil }
        }
        .background(Color.background.secondary)
        .animation(.easeInOut, value: controller.selectedPage)
    }

    public func select(page: Int) {
        guard pages.indices.contains(page) else { return }
        controller.select(page: page)
    }

    public func showProgressBar(_ isShow: Bool) -> PagerView {
        var view = self
        view.isProgressVisible = isShow
        return view
    }
}

struct PagerViewPreviews: PreviewProvider {
    static var previews: some View {
        PagerView(pages: [
            .init(id: "red", content: .init(Color.red))
        ]).showProgressBar(true)
    }
}

private extension AnyTransition {
    static var pageLeft: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }

    static var pageRight: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing)
        )
    }
}
