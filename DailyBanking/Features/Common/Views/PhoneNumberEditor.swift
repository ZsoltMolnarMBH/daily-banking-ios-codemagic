//
//  PhoneNumberEditor.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 03..
//

import DesignKit
import SwiftUI
import UIKit
import PhoneNumberKit

extension DesignTextField.EditorModel {
    var makePhoneNumberEditor: AnyView {
        .init(PhoneEditorView(
            text: $text,
            prompt: prompt,
            textColor: textColor,
            cursorColor: cursorColor
        ))
    }
}

private struct PhoneEditorView: View {
    @Binding var text: String
    let prompt: String
    let textColor: Color
    let cursorColor: Color

    var body: some View {
        PhoneNumberField(
            phoneNumber: $text,
            prompt: prompt,
            textColor: textColor,
            cursorColor: cursorColor
        )
    }
}

private struct PhoneNumberField: UIViewRepresentable {
    @Binding var phoneNumber: String
    let prompt: String
    let textColor: Color
    let cursorColor: Color

    private let textField = HungarianPhoneNumberTextField()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = false
        textField.withFlag = false
        textField.withPrefix = false
        textField.keyboardType = .numberPad
        textField.textContentType = .telephoneNumber
        textField.placeholder = ""
        textField.tintColor = UIColor(cursorColor)
        textField.textColor = UIColor(textColor)
        textField.font = TextStyle.body1.uiFont
        textField.maxDigits = 9
        textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
        return textField
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
        view.text = phoneNumber
        view.tintColor = UIColor(cursorColor)
        view.textColor = UIColor(textColor)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        var control: PhoneNumberField

        init(_ control: PhoneNumberField) {
            self.control = control
        }

        @objc func onTextUpdate(textField: UITextField) {
            self.control.phoneNumber = textField.text!
        }
    }
}

private class HungarianPhoneNumberTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "HU"
        }
        set {}
    }
}
