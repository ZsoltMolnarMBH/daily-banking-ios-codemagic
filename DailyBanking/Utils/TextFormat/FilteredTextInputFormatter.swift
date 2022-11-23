//
//  FilteredTextInputFormatter.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 18..
//

import AnyFormatKit

class FilteredTextInputFormatter: DefaultTextInputFormatter {
    let allowedInput: CharacterSet

    init(allowedInput: CharacterSet, textPattern: String, patternSymbol: Character = "#") {
        self.allowedInput = allowedInput
        super.init(textPattern: textPattern, patternSymbol: patternSymbol)
    }

    override func formatInput(currentText: String, range: NSRange, replacementString text: String) -> FormattedTextValue {
        let filteredInput = String(text.unicodeScalars.filter { self.allowedInput.contains($0) })
        return super.formatInput(currentText: currentText, range: range, replacementString: filteredInput)
    }
}
