//
//  CardButton.swift
//  DesignKit
//
//  Created by Alexa Mark on 2021. 11. 11..
//

import SwiftUI

public struct CardButton: OverrideableContentType, View {
    @Environment(\.isEnabled) var isEnabled

    public struct AnalyticsData {
        public let title: String
        public let contentTypeOverride: String?
        public let subtitle: String?
        public let style: Style
    }
    var analyticsData: AnalyticsData {
        .init(title: title,
              contentTypeOverride: contentTypeOverride,
              subtitle: subtitle,
              style: style)
    }

    private var isLocked = false
    let cornerRadius: CGFloat
    let headline: String?
    let title: String
    let subtitle: String?
    let tertiaryTitle: String?
    let image: Image?
    let leftView: AnyView?
    let rightView: AnyView?
    let imageBadge: ImageBadge?
    let style: CardButton.Style
    let clearBackground: Bool
    let supplementaryImage: Image?
    let action: () -> Void
    public var contentTypeOverride: String?

    public enum Style: String {
        case primary
        case secondary
        case destructive
    }

    public enum ImageBadge {
        case checked
        case error
    }

    public init(
        cornerRadius: CGFloat = .l,
        headline: String? = nil,
        title: String,
        subtitle: String? = nil,
        tertiaryTitle: String? = nil,
        image: Image? = nil,
        leftView: AnyView? = nil,
        rightView: AnyView? = nil,
        imageBadge: ImageBadge? = nil,
        style: CardButton.Style = .primary,
        clearBackground: Bool = false,
        supplementaryImage: Image? = Image(.chevronRight),
        action: @escaping () -> Void
    ) {
        self.cornerRadius = cornerRadius
        self.action = action
        self.headline = headline
        self.title = title
        self.subtitle = subtitle
        self.tertiaryTitle = tertiaryTitle
        self.image = image
        self.leftView = leftView
        self.rightView = rightView
        self.imageBadge = imageBadge
        self.style = style
        self.clearBackground = clearBackground
        self.supplementaryImage = supplementaryImage
    }

    public var body: some View {
        Button(action: {
            action()
            DesignKitModule.analytics?.log(buttonPress: analyticsData)
        }, label: {
            HStack(spacing: 0) {
                if let image = self.image {
                    CardButtonImage(
                        image: image,
                        size: style.imageCircleSize,
                        imageBadge: imageBadge,
                        circleColor: isEnabled ? style.imageCircleColor : Color.background.primaryDisabled,
                        imageColor: isEnabled ? style.imageColor : .text.disabled
                    )
                }
                if let leftView = leftView {
                    leftView
                }
                VStack(alignment: .leading, spacing: .s) {
                    VStack(alignment: .leading, spacing: .xxs) {
                        if let headline = headline {
                            Text(headline)
                                .textStyle(.body2)
                                .foregroundColor(isEnabled ? .text.tertiary : .text.disabled)
                        }
                        Text(title)
                            .textStyle(style.titleStyle)
                            .foregroundColor(isEnabled ? style.titleColor : .text.disabled)
                        if let subtitle = self.subtitle {
                            Text(subtitle)
                                .textStyle(.body2.condensed)
                                .foregroundColor(isEnabled ? .text.secondary : .text.disabled)
                        }
                    }
                    if let tertiaryTitle = self.tertiaryTitle {
                        Text(tertiaryTitle)
                            .textStyle(.body2.condensed)
                            .foregroundColor(isEnabled ? .text.tertiary : .text.disabled)
                    }
                }
                .padding(.leading, .m)
                Spacer()
                if let rightView = rightView {
                    rightView
                }

                if isLocked {
                    Image(.lock)
                        .resizable()
                        .foregroundColor(.text.disabled)
                        .frame(width: 24, height: 24)

                } else if let supplementaryImage = supplementaryImage {
                    supplementaryImage
                        .resizable()
                        .foregroundColor(Color.element.tertiary)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, .m)
            .padding(.vertical, .s)
            .disabled(isLocked)
        })
        .buttonStyle(ThemedButtonStyle(clearBackground: clearBackground))
        .cornerRadius(cornerRadius)
        .disabled(isLocked)
    }

    public func locked(_ isLocked: Bool) -> Self {
        var view = self
        view.isLocked = isLocked
        return view
    }
}

private struct CardButtonImage: View {
    let image: Image
    let size: CGFloat
    let imageBadge: CardButton.ImageBadge?
    let circleColor: Color
    let imageColor: Color

    public init(
        image: Image,
        size: CGFloat,
        imageBadge: CardButton.ImageBadge? = nil,
        circleColor: Color,
        imageColor: Color
    ) {
        self.image = image
        self.size = size
        self.imageBadge = imageBadge
        self.circleColor = circleColor
        self.imageColor = imageColor
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(circleColor)
                .frame(width: size, height: size)
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .xl, height: .xl)
                .foregroundColor(imageColor)
            if let imageBadge = imageBadge {
                ZStack {
                    Circle()
                        .fill(imageBadge.backgroundColor)
                        .frame(width: 24, height: 24)
                    imageBadge.image
                        .resizable()
                        .frame(width: .m, height: .m)
                        .foregroundColor(imageBadge.foregroundColor)
                }
                .offset(x: 20, y: 12)
            }
        }
    }
}

private extension CardButton.Style {
    var imageCircleColor: Color {
        switch self {
        case .primary:
            return .action.secondary.default.background
        case .secondary:
            return .background.secondary
        case .destructive:
            return .destructive.secondary.default.background
        }
    }

    var imageCircleSize: CGFloat {
        switch self {
        case .primary:
            return 48
        case .secondary:
            return 36
        case .destructive:
            return 48
        }
    }

    var imageColor: Color {
        switch self {
        case .primary:
            return .action.secondary.default.foreground
        case .secondary:
            return .text.tertiary
        case .destructive:
            return .destructive.secondary.default.foreground
        }
    }

    var titleColor: Color {
        switch self {
        case .primary:
            return Color.text.primary
        case .secondary:
            return Color.text.primary
        case .destructive:
            return Color.text.primary
        }
    }

    var titleStyle: TextStyle {
        switch self {
        case .primary:
            return .headings5
        case .secondary:
            return .body2
        case .destructive:
            return .headings5
        }
    }

    var subtitleStyle: TextStyle {
        switch self {
        case .primary:
            return .body2
        case .secondary:
            return .body3
        case .destructive:
            return .body2
        }
    }
}

private extension CardButton.ImageBadge {
    var image: Image {
        switch self {
        case .checked:
            return Image(.check)
        case .error:
            return Image(.close)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .checked:
            return .success.primary.background
        case .error:
            return .error.primary.background
        }
    }

    var foregroundColor: Color {
        switch self {
        case .checked:
            return .success.primary.foreground
        case .error:
            return .error.primary.foreground
        }
    }
}

private struct ThemedButtonStyle: ButtonStyle {
    var clearBackground: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed ? Color.background.primaryPressed :
                    clearBackground ? Color.clear : Color.background.primary
            )
    }
}

struct CardButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ZStack {
                Color.background.secondary.edgesIgnoringSafeArea(.all)
                VStack {
                    CardButton(
                        title: "Személyes adatok",
                        image: Image(systemName: "gift"),
                        style: .destructive,
                        supplementaryImage: nil,
                        action: {})
                    CardButton(
                        headline: "1. lépés",
                        title: "Személyes adatok",
                        subtitle: "segitseg@magyarbankholding.hu",
                        image: Image(systemName: "gift"),
                        supplementaryImage: nil,
                        action: {})
                    CardButton(
                        title: "Személyes adatok",
                        subtitle: "segitseg@magyarbankholding.hu",
                        tertiaryTitle: "Munkanapokon 9:00 és 15:00 között.",
                        image: Image(systemName: "gift"),
                        rightView: AnyView(
                            Toggle("", isOn: .constant(true)).toggleStyle(SwitchToggleStyle(tint: .highlight.tertiary)).fixedSize()
                        ),
                        supplementaryImage: nil,
                        action: {})
                    CardButton(
                        title: "Hosszú szöveg, ami két sorba törik legalább...",
                        subtitle: "segitseg@magyarbankholding.hu",
                        supplementaryImage: nil,
                        action: {})
                    CardButton(
                        title: "Személyes adatok",
                        image: Image(systemName: "gift"),
                        imageBadge: .error,
                        action: {})
                    CardButton(
                        headline: "1. lépés",
                        title: "Személyes adatok",
                        image: Image(systemName: "gift"),
                        imageBadge: .checked,
                        action: { fatalError() })
                        .locked(true)
                        .disabled(true)
                    CardButton(
                        title: "Személyes adatok",
                        supplementaryImage: Image(.close),
                        action: { }
                    )
                    CardButton(
                        title: "Személyes adatok",
                        leftView: AnyView(MonogramView(monogram: "IZS", size: .medium)),
                        action: {}
                    )
                    CardButton(
                        title: "Személyes adatok",
                        leftView: AnyView(MonogramView(monogram: "IZS", size: .medium)),
                        clearBackground: true,
                        action: {}
                    )
                    CardButton(
                        title: "Személyes adatok",
                        image: Image(systemName: "gift"),
                        style: .secondary,
                        action: {}
                    )
                }
                .padding()
            }
        }
        .preferredColorScheme(.light)
    }
}
