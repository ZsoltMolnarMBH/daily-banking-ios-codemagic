//
//  TextStyle.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 10. 28..
//

import SwiftUI
import UIKit

public extension TextStyle {
    // MARK: Heading
    static let headings1 = TextStyle(.bold, size: 40, lineHeight: 48)
    static let headings2 = TextStyle(.bold, size: 32, lineHeight: 40)
    static let headings3 = TextStyle(.bold, size: 24, lineHeight: 32)
    static let headings4 = TextStyle(.bold, size: 20, lineHeight: 28)
    static let headings5 = TextStyle(.bold, size: 16, lineHeight: 24)
    static let headings6 = TextStyle(.bold, size: 14, lineHeight: 20)
    static let headings7 = TextStyle(.bold, size: 12, lineHeight: 16)
    static let headings8 = TextStyle(.bold, size: 8, lineHeight: 12)

    // MARK: Body
    static let body1 = TextStyle(.book, size: 16, lineHeight: 28)
    static let body2 = TextStyle(.book, size: 14, lineHeight: 24)
    static let body3 = TextStyle(.book, size: 12, lineHeight: 20)
}

public extension TextStyle {
    internal init(_ style: Fonts.CircularXXStyle, size: CGFloat, lineHeight: CGFloat) {
        let weight: Font.Weight
        switch style {
        case .bold:
            weight = .bold
        case .book:
            weight = .medium
        }
        self.init(fontName: style.rawValue, size: size, lineHeight: lineHeight, weight: weight)
    }

    var thin: TextStyle {
        var style = self
        style.fontName = Fonts.CircularXXStyle.book.rawValue
        style.weight = .medium
        return style
    }

    var condensed: TextStyle {
        var style = self
        if let lineHeight = style.lineHeight {
            style.lineHeight = lineHeight - 4
        }
        return style
    }
}

public struct TextStyle {
    public var fontName: String
    public var size: CGFloat
    public var weight: Font.Weight
    public var lineHeight: CGFloat?

    public init(fontName: String, size: CGFloat, lineHeight: CGFloat? = nil, weight: Font.Weight = .medium) {
        self.fontName = fontName
        self.size = size
        self.weight = weight
        self.lineHeight = lineHeight
    }

    public var font: Font {
        return Font.custom(fontName, size: size, relativeTo: .body)
    }

    public var uiFont: UIFont {
        return UIFontMetrics.default.scaledFont(for: UIFont(name: fontName, size: size)!)
    }

    public func lineSpacingFor(height: CGFloat) -> CGFloat {
        return (height - size) / 2
    }
}

public extension View {
    @ViewBuilder
    func textStyle(_ model: TextStyle, applyPadding: Bool = false) -> some View {
        if let lineHeight = model.lineHeight {
            self.textStyle(model, lineHeight: lineHeight, applyPadding: applyPadding)
        } else {
            self.font(model.font)
        }
    }

    @ViewBuilder
    func textStyle(_ model: TextStyle, lineHeight: CGFloat, applyPadding: Bool = false) -> some View {
        self
            .font(model.font)
            .lineSpacing(model.lineSpacingFor(height: lineHeight))
            .padding(.vertical, applyPadding
                     ? (model.lineSpacingFor(height: lineHeight) / 2)
                     : 0)
    }
}
