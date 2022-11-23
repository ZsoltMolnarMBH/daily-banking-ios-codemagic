//
//  CurrencyHUFEditor.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 09..
//

import DesignKit
import SwiftUI
import AnyFormatKitSwiftUI
import AnyFormatKit

// editor: .custom(factory: { $0.makeAccountEditorEditor }),

extension DesignTextField.EditorModel {
    var makeCurrencyHufEditorEditor: AnyView {
        .init(CurrencyHufEditorView(
            text: $text,
            prompt: prompt,
            textColor: textColor,
            cursorColor: cursorColor
        ))
    }
}

private struct CurrencyHufEditorView: View {
    @Binding var text: String
    var textNumber: Binding<NSNumber?> { Binding(
        get: {
            guard let text = Double(text) else { return nil}
            return NSNumber(value: text)
        },
        set: {
            text = $0?.stringValue ?? ""
        })
    }
    let prompt: String
    let textColor: Color
    let cursorColor: Color

    var body: some View {
        FormatSumTextField(
            numberValue: textNumber,
            formatter: SumTextInputFormatter(textPattern: "# ###,#")
        )
            .textStyle(.body1)
            .keyboardType(.numberPad)
            .foregroundColor(textColor)
            .accentColor(cursorColor)

    }
}
