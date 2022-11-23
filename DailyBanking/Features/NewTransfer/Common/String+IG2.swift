//
//  String+IG2.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 23..
//

import Foundation

extension String {
    func ig2Escaped() -> String {
        var escaped = self
        let escapes = [
            ("&", "&amp;"),      // ampersand
            ("\"", "&quot;"),    // quotation mark
            ("'", "&apos;"),     // apostrophe
            ("<", "&lt;"),       // less than
            (">", "&gt;")        // greater than
        ]
        escapes.forEach { (key, value) in
            escaped = escaped.replacingOccurrences(of: key, with: value)
        }
        return escaped // ">" -> "&amp;gt;"
    }
}

extension CharacterSet {
    static let ig2Allowed = CharacterSet(charactersIn: Unicode.Scalar(32)...Unicode.Scalar(126))
        .union(CharacterSet(charactersIn: "áéíóöőüűÁÉÍÓÖŐÜŰ"))
}
