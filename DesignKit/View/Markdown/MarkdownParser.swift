//
//  MarkdownParser.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 06. 09..
//

import Foundation

class MarkdownParser {
    func parse(text: String) -> Markdown.Document {
        let textLines = text
            .replacingOccurrences(of: "\n\n", with: "\n \n") // Disable squashing multiple newlines
            .split(whereSeparator: \.isNewline)
            .map { String($0)}
        var documentlines: [Markdown.Document.Line] = []
        var numberedListCount = 0
        for line in textLines {
            // The utf16 count to avoid problems with emoji and similar
            let fullRangeOfLine = NSRange(location: 0, length: line.utf16.count)
            var documentLine = Markdown.Document.Line(prefix: nil, text: line, style: .body)
            for style in Markdown.Style.allCases {
                if let pattern = style.syntaxPattern, let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                    if let match = regex.firstMatch(in: line, range: fullRangeOfLine) {
                        if style == .numberedList {
                            numberedListCount += 1
                        } else {
                            numberedListCount = 0
                        }
                        let trimmedLine = String(line.dropFirst(match.range.upperBound))
                        let prefix = style.visualPrefix(listCount: numberedListCount)
                        documentLine = Markdown.Document.Line(prefix: prefix, text: trimmedLine, style: style)
                        break
                    }
                }
            }
            documentlines.append(documentLine)
        }

        return .init(lines: documentlines)
    }
}

extension Markdown.Style {
    var syntaxPattern: String? {
        switch self {
        case .heading1:
            return "^# "
        case .heading2:
            return "^## "
        case .heading3:
            return "^### "
        case .heading4:
            return "^#### "
        case .heading5:
            return "^##### "
        case .heading6:
            return "^###### "
        case .body:
            return nil
        case .numberedList:
            return #"^\d. "#
        case .bulletPointList:
            return #"^\* "#
        case .horizontalRule:
            return "---$"
        }
    }

    func visualPrefix(listCount: Int) -> String {
        switch self {
        case .numberedList:
            return " \(listCount). "
        case .bulletPointList:
            return " • "
        default:
            return ""
        }
    }
}
