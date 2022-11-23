//
//  VerticalButton.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2021. 12. 16..
//

import SwiftUI

public struct VerticalButton: OverrideableContentType, View {
    public struct AnalyticsData {
        public let style: Style
        public let contentTypeOverride: String?
        public let text: String?
    }
    var analyticsData: AnalyticsData {
        .init(style: style,
              contentTypeOverride: contentTypeOverride,
              text: text)
    }

    public enum Style: String {
        case primary
        case secondary
    }

    private let text: String
    private let imageName: String
    private let style: Style
    private let action: () -> Void
    public var contentTypeOverride: String?

    public init(text: String, imageName: String, style: Style, action: @escaping () -> Void) {
        self.text = text
        self.imageName = imageName
        self.style = style
        self.action = action
    }

    @Environment(\.isEnabled) private var isEnabled

    public var body: some View {
        VStack {
            Button {
                action()
                DesignKitModule.analytics?.log(buttonPress: analyticsData)
            } label: {
                VStack {
                    Image(imageName)
                        .resizable()
                        .frame(width: 21, height: 21)
                        .frame(width: 48, height: 48)
                        .padding(0)
                }
            }
            .buttonStyle(VerticalButton.ButtonStyle(style: style))
            Text(text)
                .textStyle(.headings7)
                .foregroundColor(style.textColor(isEnabled: isEnabled))
                .padding(0)
                .multilineTextAlignment(.center)
        }
    }
}

extension VerticalButton {
    private struct ButtonStyle: SwiftUI.ButtonStyle {
        @Environment(\.isEnabled) var isEnabled
        private let style: VerticalButton.Style

        init(style: VerticalButton.Style) {
            self.style = style
        }

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 48, height: 48, alignment: .top)
                .background(
                    Circle()
                        .fill(style.backgroundColor(isEnabled: isEnabled,
                                                    isPressed: configuration.isPressed))
                )
                .foregroundColor(style.iconColor(isEnabled: isEnabled,
                                                 isPressed: configuration.isPressed))
        }
    }
}

private extension VerticalButton.Style {
    func backgroundColor(isEnabled: Bool, isPressed: Bool) -> Color {
        switch self {
        case .primary:
            if !isEnabled {
                return .action.primary.disabled.background
            } else if isPressed {
                return .action.primary.pressed.background
            } else {
                return .action.primary.default.background
            }
        case .secondary:
            if !isEnabled {
                return .action.secondary.disabled.background
            } else if isPressed {
                return .action.secondary.pressed.background
            } else {
                return .action.secondary.default.background
            }
        }
    }

    func iconColor(isEnabled: Bool, isPressed: Bool) -> Color {
        switch self {
        case .primary:
            if !isEnabled {
                return .action.primary.disabled.foreground
            } else if isPressed {
                return .action.primary.pressed.foreground
            } else {
                return .action.primary.default.foreground
            }
        case .secondary:
            if !isEnabled {
                return .action.secondary.disabled.foreground
            } else if isPressed {
                return .action.secondary.pressed.foreground
            } else {
                return .action.secondary.default.foreground
            }
        }
    }

    func textColor(isEnabled: Bool) -> Color {
        if !isEnabled {
            return .action.secondary.disabled.foreground
        } else {
            return .action.secondary.default.foreground
        }
    }
}

public extension VerticalButton {
    init(text: String, imageName: ImageName, style: Style, action: @escaping () -> Void) {
        self.init(text: text,
                  imageName: imageName.rawValue,
                  style: style,
                  action: action)
    }
}

struct VerticalButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .xxl) {
            VerticalButton(text: "Go right", imageName: .chevronRight, style: .primary) { }
            VerticalButton(text: "Calendar\nmagic", imageName: .calendar, style: .secondary) { }
            VerticalButton(text: "Secret option", imageName: .check, style: .secondary) { }
            .disabled(true)
        }
        .preferredColorScheme(.light)
    }
}
