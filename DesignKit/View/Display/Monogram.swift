//
//  Monogram.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 21..
//

import Foundation
import SwiftUI

public struct MonogramView: View {
    @Environment(\.isEnabled) var isEnabled

    public enum Style {
        case primary, secondary
    }

    public enum Size {
        case extraSmall, small, medium, large
    }

    let monogram: String
    var componentSize: Size
    var style: Style

    public init(monogram: String,
                size: Size = .large,
                style: Style = .primary) {
        self.monogram = monogram
        self.componentSize = size
        self.style = style
    }

    public var body: some View {
        ZStack {
            backgroundColor
                .frame(width: size, height: size)
                .clipShape(Circle())
            Text(monogram)
                .foregroundColor(textColor)
                .textStyle(textStyle)
        }
    }

    var size: CGFloat {
        switch componentSize {
        case .extraSmall:
            return 24
        case .small:
            return 40
        case .medium:
            return 48
        case .large:
            return 72
        }
    }

    var backgroundColor: Color {
        if isEnabled {
            switch style {
            case .primary:
                return .action.primary.default.background
            case .secondary:
                return .action.secondary.default.background
            }
        } else {
            return .action.primary.disabled.background
        }
    }

    var textColor: Color {
        if isEnabled {
            switch style {
            case .primary:
                return .action.primary.default.foreground
            case .secondary:
                return .action.secondary.default.foreground
            }
        } else {
            return .action.primary.disabled.foreground
        }
    }

    var textStyle: TextStyle {
        switch componentSize {
        case .extraSmall:
            return .body3
        case .small:
            return .body1
        case .medium:
            return .headings4.thin
        case .large:
            return .headings2.thin
        }
    }
}

public extension MonogramView {
    func style(_ style: Style) -> MonogramView {
        var view = self
        view.style = style
        return view
    }
}

struct MonogramView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MonogramView(
                monogram: "IA",
                size: .extraSmall
            )
            .disabled(true)
            .padding()

            MonogramView(
                monogram: "Hello",
                size: .small
            ).padding()

            MonogramView(
                monogram: "IA",
                size: .medium
            ).padding()

            MonogramView(
                monogram: "IA",
                size: .medium
            )
            .style(.secondary)
            .padding()

            MonogramView(
                monogram: "IA",
                size: .large
            )
            .disabled(true)
            .padding()
        }.preferredColorScheme(.light)
    }
}
