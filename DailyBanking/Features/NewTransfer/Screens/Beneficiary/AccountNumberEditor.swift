//
//  AccountNumberEditor.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 08..
//

import DesignKit
import SwiftUI
import AnyFormatKit
import AnyFormatKitSwiftUI

extension DesignTextField.EditorModel {
    func makeAccountEditorEditor(onReturn: @escaping () -> Void) -> AnyView {
        .init(AccountEditorView(text: $text,
                                prompt: prompt,
                                textColor: textColor,
                                cursorColor: cursorColor,
                                onReturn: onReturn)
        )
    }
}

private struct AccountEditorView: View {
    @Binding var text: String
    let prompt: String
    let textColor: Color
    let cursorColor: Color
    let onReturn: () -> Void

    var body: some View {
        FormatTextField(unformattedText: $text,
                        placeholder: prompt,
                        formatter: FilteredTextInputFormatter(
                            allowedInput: .decimalDigits,
                            textPattern: "######## - ######## - ########"))
            .onReturn(perform: onReturn)
            .textStyle(.body1)
            .keyboardType(.numberPad)
            .foregroundColor(textColor)
            .accentColor(cursorColor)
    }
}
