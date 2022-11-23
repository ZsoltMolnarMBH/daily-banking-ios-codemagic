//
//  InfoView.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 01. 02..
//

import SwiftUI

public struct InfoView: View {
    public let chips: [ChipView] // 🐟&🍟=👑
    public let secure: Bool
    public let title: String
    public let text: String
    public let subtitle: String?

    public var titleColor = Color.text.tertiary
    public var textColor = Color.text.primary
    public var subtitleColor = Color.text.secondary
    public var titleFont = TextStyle.body2
    public var textFont = TextStyle.headings5

    public init(title: String, text: String, chips: [ChipView] = [], subtitle: String? = nil, secure: Bool = false) {
        self.title = title
        self.text = text
        self.chips = chips
        self.secure = secure
        self.subtitle = subtitle
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .xxs) {
                HStack {
                    Text(title)
                        .textStyle(titleFont)
                        .foregroundColor(titleColor)
                    ForEach(Array(chips.enumerated()), id: \.offset) {
                        $0.element
                    }
                }
                if secure {
                    SecureLabel(text: text)
                        .textStyle(.headings5)
                        .foregroundColor(Color.text.primary)
                        .fixedSize()
                } else {
                    Text(text)
                        .textStyle(textFont)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(textColor)
                }
                if let subtitle = subtitle {
                    Text(subtitle)
                        .textStyle(.body2)
                        .foregroundColor(subtitleColor)
                }
            }
            Spacer()
        }
    }
}

public extension InfoView {
    func titleColor(_ color: Color) -> Self {
        var view = self
        view.titleColor = color
        return view
    }

    func textColor(_ color: Color) -> Self {
        var view = self
        view.textColor = color
        return view
    }

    func subtitleColor(_ color: Color) -> Self {
        var view = self
        view.subtitleColor = color
        return view
    }

    func titleStyle(_ style: TextStyle) -> Self {
        var view = self
        view.titleFont = style
        return view
    }

    func textStyle(_ style: TextStyle) -> Self {
        var view = self
        view.textFont = style
        return view
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InfoView(title: "Számlaszám", text: "12345678-12345678-12345678")
            InfoView(title: "Számlaszám", text: "12345678 - 12345678 - 12345678 - 12345678 - 12345678 - 12345678")
            InfoView(title: "Számlaszám",
                     text: "12345678-12345678-12345678",
                     chips: [ChipView(text: "expired",
                                      backgroundColor: .error.secondary.background,
                                      textColor: .error.secondary.foreground,
                                      size: .small)])
            InfoView(title: "Transfer date", text: "2023 01 12", subtitle: "Instant payment")
        }
    }
}
