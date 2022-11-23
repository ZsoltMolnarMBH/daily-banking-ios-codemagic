//
//  ShimmeringView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 28..
//

import Foundation
import SwiftUI

extension Gradient {
    static func shimmer(for background: Color) -> Gradient {
        Gradient(stops: [
            .init(color: .element.tertiary, location: 0),
            .init(color: .element.tertiary, location: 0.125),
            .init(color: background, location: 0.188),
            .init(color: .element.tertiary, location: 0.250),
            .init(color: .element.tertiary, location: 1)
        ])
    }
}

public struct ShimmeringView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    private let content: () -> Content
    private let gradient: Gradient

    public init(gradient: Gradient, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.gradient = gradient
    }

    public var body: some View {
        ZStack {
            content().layoutPriority(1)
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    let offset: Double = now.truncatingRemainder(dividingBy: 2)

                    let start = CGPoint(x: -size.width * (7 - (offset * 3.5)), y: 0)
                    let rect = CGRect(
                        origin: start,
                        size: .init(
                            width: size.width * 8,
                            height: size.height
                        )
                    )
                    let path = Path(rect)
                    let gradientStart = CGPoint(
                        x: start.x,
                        y: 0.5 * size.height
                    )
                    let gradientEnd = CGPoint(
                        x: start.x + (size.width * 8),
                        y: 0.5 * size.height
                    )
                    context.fill(
                        path,
                        with: .linearGradient(
                            gradient,
                            startPoint: gradientStart,
                            endPoint: gradientEnd
                        )
                    )
                }
            }
            .blendMode(colorScheme == .light ? .lighten : .darken)
            .layoutPriority(0)
        }
    }
}

public struct ShimmerModifier: ViewModifier {
    let gradient: Gradient
    public func body(content: Content) -> some View {
        ShimmeringView(gradient: gradient) { content }
    }
}

public extension View {
    @ViewBuilder
    func shimmeringPlaceholder(when condition: Bool, for background: Color) -> some View {
        if condition {
            redacted(reason: .placeholder)
                .modifier(ShimmerModifier(gradient: .shimmer(for: background)))
        } else {
            self
        }
    }

    @ViewBuilder
    func redacted(when condition: Bool) -> some View {
        if condition {
            self.redacted(reason: .placeholder)
        } else {
            self
        }
    }
}

struct ShimmeringView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background.secondary.ignoresSafeArea()
            ZStack {
                Card {
                    CircularProgressView(
                        progress: 1
                    )
                    .foregroundColor(Colors.grey500)

                    Image(.viewOff)
                        .resizable()
                        .frame(width: 72, height: 72)
                        .cornerRadius(10)
                }
            }
            .shimmeringPlaceholder(when: true, for: .background.primary)
        }.preferredColorScheme(.dark)
    }
}
