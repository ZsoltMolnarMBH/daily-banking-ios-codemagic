//
//  HapticOnTouch.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 05. 02..
//

import SwiftUI

public extension View {
    @ViewBuilder
    func hapticOnTouch(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        HapticView(style: style) { self }
    }
}

private struct HapticView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @State private var isTouched = false
    private let style: UIImpactFeedbackGenerator.FeedbackStyle

    init(style: UIImpactFeedbackGenerator.FeedbackStyle, @ViewBuilder content: @escaping () -> Content) {
        self.style = style
        self.content = content
    }

    var body: some View {
        content()
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        let haptic = UIImpactFeedbackGenerator(style: style)
                        if !isTouched { haptic.impactOccurred() }
                        isTouched = true
                    }
                    .onEnded { _ in
                        isTouched = false
                    }
            )
    }
}
