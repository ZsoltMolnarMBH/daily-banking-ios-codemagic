//
//  StyledButton.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 20..
//

import SwiftUI

public struct DesignButton: OverrideableContentType, View {
    public struct AnalyticsData {
        public let style: Style
        public let contentTypeOverride: String?
        public let title: String?
    }
    var analyticsData: AnalyticsData {
        .init(style: style,
              contentTypeOverride: contentTypeOverride,
              title: title)
    }

    public enum Width {
        case fluid, fullSize
    }

    public enum Size {
        case small, medium, large, giant

        public var diameter: CGFloat {
            switch self {
            case .small:
                return 28
            case .medium:
                return 36
            case .large:
                return 48
            case .giant:
                return 60
            }
        }
    }

    public enum Style: String {
        case primary
        case secondary
        case tertiary
        case destructive
    }

    let style: Style
    let width: Width
    let size: Size
    let title: String?
    let imageName: String?
    let action: () -> Void
    public var contentTypeOverride: String?
    public var isEnableAnalytics = true

    public init(
        style: Style = .primary,
        width: Width = .fullSize,
        size: Size = .large,
        title: String? = nil,
        imageName: ImageName,
        action: @escaping () -> Void) {
        self.init(style: style,
                  width: width,
                  size: size,
                  title: title,
                  imageName: imageName.rawValue,
                  action: action)
    }

    public init(
        style: Style = .primary,
        width: Width = .fullSize,
        size: Size = .large,
        title: String? = nil,
        imageName: String? = nil,
        action: @escaping () -> Void) {
        self.style = style
        self.width = width
        self.size = size
        self.title = title
        self.imageName = imageName
        self.action = action
    }

    public var body: some View {
        Button(
            action: {
                action()
                if isEnableAnalytics {
                    DesignKitModule.analytics?.log(buttonPress: analyticsData)
                }
            },
            label: {
                HStack(spacing: 0) {
                    if width == .fullSize {
                        Spacer()
                    }
                    HStack(spacing: .xxs) {
                        if let imageName = self.imageName {
                            Image(imageName)
                                .resizable()
                                .frame(width: imageSize, height: imageSize)
                        }
                        if let title = title, hasTitle {
                            Text(title)
                                .multilineTextAlignment(.center)
                        }
                    }
                    if width == .fullSize {
                        Spacer()
                    }
                }
                .padding(.horizontal, padding)
                .frame(minWidth: height)
                .frame(height: height)
            })
            .buttonStyle(DesignHighlight(style: style))
            .textStyle(textStyle)
    }

    var hasTitle: Bool {
        if let title = title {
            return !title.isEmpty
        }
        return false
    }

    var height: CGFloat {
        size.diameter
    }

    var padding: CGFloat {
        switch size {
        case .small:
            return hasTitle ? .xs : .xxs
        case .medium:
            return hasTitle ? .s : .xs
        case .large:
            return hasTitle ? .m : .s
        case .giant:
            return hasTitle ? .l : .m
        }
    }

    var imageSize: CGFloat {
        switch size {
        case .small:
            return .l
        case .medium:
            return .l
        case .large:
            return .xl
        case .giant:
            return .xxl
        }
    }

    var textStyle: TextStyle {
        switch size {
        case .small:
            return .headings7
        case .medium:
            return .headings6
        case .large:
            return .headings5
        case .giant:
            return .headings4
        }
    }
}

private extension DesignButton.Style {
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
                return .clear
            }
        case .tertiary:
            return .clear
        case .destructive:
            return .clear
        }
    }

    func textColor(isEnabled: Bool, isPressed: Bool) -> Color {
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
        case .tertiary:
            if !isEnabled {
                return .action.tertiary.disabled
            } else if isPressed {
                return .action.tertiary.pressed
            } else {
                return .action.tertiary.default
            }
        case .destructive:
            if !isEnabled {
                return .destructive.tertiary.disabled
            } else if isPressed {
                return .destructive.tertiary.pressed
            } else {
                return .destructive.tertiary.default
            }
        }
    }
}

public struct DesignHighlight: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    private let style: DesignButton.Style

    init(style: DesignButton.Style) {
        self.style = style
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Group {
                    switch style {
                    case .secondary:
                        ZStack {
                            Capsule().fill(
                                style.backgroundColor(
                                    isEnabled: isEnabled,
                                    isPressed: configuration.isPressed)
                            )
                            Capsule()
                                .stroke(
                                    style.textColor(
                                        isEnabled: isEnabled,
                                        isPressed: configuration.isPressed
                                    ), lineWidth: 2)
                        }
                    default:
                        Capsule().fill(
                            style.backgroundColor(
                                isEnabled: isEnabled,
                                isPressed: configuration.isPressed)
                        )
                    }
                }
            )
            .contentShape(Capsule())
            .foregroundColor(
                style.textColor(
                    isEnabled: isEnabled,
                    isPressed: configuration.isPressed
                )
            )
    }
}

public extension DesignButton {
    func disableAnalytics() -> some View {
        var button = self
        button.isEnableAnalytics = false
        return button
    }
}

struct DesignButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DesignButton(
                style: .primary,
                width: .fluid,
                size: .small,
                imageName: .info,
                action: {}
            )
            .disabled(true)

            DesignButton(
                style: .primary,
                width: .fluid,
                size: .medium,
                imageName: .info,
                action: {}
            )
            .disabled(false)

            DesignButton(
                style: .primary,
                width: .fullSize,
                size: .large,
                title: "Checkout",
                imageName: .info,
                action: {}
            )
            .disabled(false)

            DesignButton(
                style: .secondary,
                width: .fluid,
                size: .medium,
                title: "Belépés",
                imageName: .info,
                action: {}
            )
            .disabled(false)

            DesignButton(
                style: .tertiary,
                width: .fluid,
                size: .medium,
                title: "Belépés",
                action: {}
            )
            .disabled(true)

            DesignButton(
                style: .destructive,
                width: .fluid,
                size: .medium,
                title: "Belépés",
                action: {}
            )
            .disabled(false)

            DesignButton(
                style: .primary,
                width: .fluid,
                size: .large,
                title: "Belejelentkezem",
                imageName: .info,
                action: {}
            )
            .disabled(false)
        }
        .preferredColorScheme(.light)
    }
}
