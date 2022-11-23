//
//  MarkdownDocument.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 06. 09..
//

import SwiftUI

public extension Markdown {
    typealias StyleMap = [Style: LineAppearance]

    enum Style: Equatable, CaseIterable {
        case heading1
        case heading2
        case heading3
        case heading4
        case heading5
        case heading6
        case body
        case numberedList
        case bulletPointList
        case horizontalRule
    }

    struct LineAppearance {
        internal init(style: TextStyle, color: Color, isAttributed: Bool) {
            self.style = style
            self.color = color
            self.isAttributed = isAttributed
        }

        let style: TextStyle
        let color: Color
        let isAttributed: Bool
    }

    struct Document: Equatable {
        let lines: [Line]

        struct Line: Equatable {
            let prefix: String?
            let text: String
            let style: Style
        }
    }
}

public extension Markdown.StyleMap {
    static let `default`: Self = Dictionary(uniqueKeysWithValues: Markdown.Style.allCases.map({ ($0, $0.defaultAppearance) }))
}

public extension Markdown.Style {
    var defaultAppearance: Markdown.LineAppearance {
        switch self {
        case .heading1:
            return .init(style: .headings1, color: .text.primary, isAttributed: false)
        case .heading2:
            return .init(style: .headings2, color: .text.primary, isAttributed: false)
        case .heading3:
            return .init(style: .headings3, color: .text.primary, isAttributed: false)
        case .heading4:
            return .init(style: .headings4, color: .text.primary, isAttributed: false)
        case .heading5:
            return .init(style: .headings5, color: .text.primary, isAttributed: false)
        case .heading6:
            return .init(style: .headings6, color: .text.primary, isAttributed: false)
        case .body:
            return .init(style: .body2, color: .text.secondary, isAttributed: true)
        case .numberedList:
            return .init(style: .body2, color: .text.secondary, isAttributed: true)
        case .bulletPointList:
            return .init(style: .body2, color: .text.secondary, isAttributed: true)
        case .horizontalRule:
            return .init(style: .body2, color: .background.primary, isAttributed: false)
        }
    }
}
