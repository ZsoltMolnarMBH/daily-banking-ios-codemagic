//
//  Markdown.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 06. 09..
//

import SwiftUI

public struct Markdown: View {
    private let document: Document
    private var styles: StyleMap = .default
    private var linkColor: Color = .highlight.tertiary
    private var linkHandler: ((URL) -> Void)?

    public init(_ text: String) {
        document = MarkdownParser().parse(text: text)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
            }
            ForEach(Array(document.lines.enumerated()), id: \.offset) { line in
                let appearance = styles[line.element.style] ?? line.element.style.defaultAppearance

                Group {
                    switch line.element.style {
                    case .horizontalRule:
                        Divider()
                    case .numberedList, .bulletPointList: // SwiftUI markdown parsing removes numbered prefixes, so we need to restore them
                        HStack(alignment: .top, spacing: 0) {
                            if let prefix = line.element.prefix {
                                Text(prefix)
                                    .frame(minWidth: 16, alignment: .leading)
                                Spacer()
                                    .frame(width: 6)
                            }
                            makeLine(isAttributed: appearance.isAttributed, text: line.element.text)
                        }
                    default:
                        makeLine(isAttributed: appearance.isAttributed, text: line.element.text)
                    }
                }
                .textStyle(appearance.style, applyPadding: true)
                .foregroundColor(appearance.color)
                .tint(linkColor)
            }
            .environment(\.openURL, OpenURLAction { url in
                linkHandler?(url)
                return .handled
            })
        }
    }

    @ViewBuilder
    private func makeLine(isAttributed: Bool, text: String) -> some View {
        if isAttributed, let attributedString = markdown(from: text) {
            Text(attributedString)
        } else {
            Text(text)
        }
    }

    private func markdown(from text: String) -> AttributedString? {
        guard var attributedString = try? AttributedString(markdown: text) else {
            return nil
        }

        for run in attributedString.runs {
            // the link attribute lets us style the links in the Markdown
            // if isLink
            if run.attributes[AttributeScopes.FoundationAttributes.LinkAttribute.self] != nil {
                attributedString[run.range].underlineStyle = .single
            }
        }

        return attributedString
    }
}

public extension Markdown {
    func style(_ styles: StyleMap) -> Markdown {
        var view = self
        view.styles = styles
        return view
    }

    func linkColor(_ linkColor: Color) -> Markdown {
        var view = self
        view.linkColor = linkColor
        return view
    }

    func onLinkTapped(_ linkHandler: ((URL) -> Void)?) -> Markdown {
        var view = self
        view.linkHandler = linkHandler
        return view
    }
}

struct Markdown_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            Markdown(.markdownSample)
                .padding()
        }
    }
}
