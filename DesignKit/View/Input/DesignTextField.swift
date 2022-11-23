//
//  DesignTextField.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 22..
//

import SwiftUI
import UIKit

public enum ValidationState: Equatable {
    case normal
    case loading
    case validated
    case warning(text: String)
    case error(text: String)
}

public struct DesignTextField: TrimmedTextInput {
    public struct EditorModel {
        @Binding public var text: String
        public let prompt: String
        public let textColor: Color
        public let cursorColor: Color
    }

    public enum Editor {
        case normal
        case secured(onSubmit: () -> Void)
        case custom(factory: (EditorModel) -> AnyView)
    }

    // MARK: Constants
    private let cornerRadius: CGFloat = 10
    private let height: CGFloat = 48

    // MARK: Given propeties
    let title: String
    let prefix: String
    let suffix: String
    let prefixImage: Image?
    let prompt: String
    let hint: String
    let infoButtonText: String
    let infoButtonTextAction: () -> Void
    let infoButtonImageAction: (() -> Void)?
    let editor: Editor
    @Binding var text: String

    // MARK: TextInputCommon
    @Environment(\.isEnabled) public var isEnabled
    public var isViewOnly: Bool = false
    public var viewOnlyTapAction: (() -> Void)?
    public let state: ValidationState
    @FocusState public var focused: Bool
    @State public var isAlreadyEdited: Bool
    @State var showError: Bool = false
    public var isHidingErrorWhileEditing = false
    public var isHidingErrorBeforeEditing = false
    public var trimmedCharacters: CharacterSet? = .whitespaces

    public init(
        title: String = "",
        prefix: String = "",
        suffix: String = "",
        prefixImage: Image? = nil,
        text: Binding<String>,
        prompt: String = "",
        hint: String = "",
        infoButtonText: String = "",
        infoButtonTextAction: @escaping () -> Void = {},
        infoButtonImageAction: (() -> Void)? = nil,
        editor: Editor = .normal,
        validationState: ValidationState
    ) {
        self._text = text
        self.title = title
        self.prefix = prefix
        self.suffix = suffix
        self.prefixImage = prefixImage
        self.prompt = prompt
        self.hint = hint
        self.infoButtonText = infoButtonText
        self.infoButtonTextAction = infoButtonTextAction
        self.infoButtonImageAction = infoButtonImageAction
        self.editor = editor
        self.state = validationState
        _isAlreadyEdited = State(initialValue: !text.wrappedValue.isEmpty)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DesignTextFieldHeader(
                title: title,
                infoButtonText: infoButtonText,
                infoButtonTextAction: infoButtonTextAction,
                infoButtonImageAction: infoButtonImageAction)
            ZStack {
                backgroundWithBorder

                HStack(spacing: .xs) {
                    if let prefixImage = prefixImage {
                        prefixImage
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(textColor)
                    }
                    if !prefix.isEmpty {
                        prefixView
                    }
                    switch editor {
                    case .normal:
                        EditorView(
                            text: $text,
                            state: state,
                            content: { binding in
                                TextField(
                                    prompt,
                                    text: binding
                                )
                                .textStyle(.body1)
                                .accentColor(cursorColor)
                                .foregroundColor(textColor)
                            })
                            .focused($focused)
                            .frame(height: 48)
                    case .secured(let onSubmit):
                        securedEditor(onSubmit: onSubmit)
                    case .custom(let factory):
                        EditorView(
                            text: $text,
                            state: state,
                            content: { binding in
                                factory(.init(
                                    text: binding,
                                    prompt: prompt,
                                    textColor: textColor,
                                    cursorColor: cursorColor)
                                )
                            })
                            .focused($focused)
                            .frame(height: 48)
                    }
                    if !suffix.isEmpty {
                        suffixView
                    }
                }
                .padding([.leading, .trailing], .s)
                .onChange(of: focused) { _ in
                    isAlreadyEdited = true
                    trim(text: $text)
                }
                .disabled(isViewOnly)
            }
            .simultaneousGesture(TapGesture().onEnded {
                guard isViewOnly else { return }
                viewOnlyTapAction?()
            })
            if showError {
                errorView()
            }
            if hint.count > 0 {
                hintView()
                    .padding(.top, .xs)
            }
        }
        .onChange(of: isErrorViewVisible) { value in
            withAnimation { showError = value }
        }
        .onAppear {
            showError = isErrorViewVisible
        }
        .onTapGesture { /* consume touch events - avoid passthrough touch while editing */ }
    }

    var prefixView: some View {
        Text(prefix)
            .textStyle(.body1)
            .foregroundColor(.text.tertiary)
    }

    var suffixView: some View {
        Text(suffix)
            .textStyle(.body1)
            .foregroundColor(.text.tertiary)
    }

    var backgroundWithBorder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(backgroundColor)
                .frame(height: height)
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: 2)
                .foregroundColor(borderColor)
                .frame(height: height)
        }
    }

    func hintView() -> some View {
        Text(hint)
            .textStyle(.body2)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .foregroundColor(.text.tertiary)
    }

    func securedEditor(onSubmit: @escaping () -> Void) -> some View {
        SecureEditorView(
            text: $text,
            onSubmit: onSubmit,
            prompt: prompt,
            textColor: textColor,
            cursorColor: cursorColor
        )
        .focused($focused)
        .frame(height: 48)
    }
}

private struct EditorView<Content: View>: View {
    @Environment(\.isEnabled) var isEnabled
    @FocusState var focused: Bool

    @Binding var text: String
    let state: ValidationState
    let content: (Binding<String>) -> Content

    var body: some View {
        HStack(spacing: .s) {
            content($text)
                .padding([.top, .bottom], .xs)
                .focused($focused)
            switch state {
            case .validated:
                Image(.check)
                    .resizable()
                    .foregroundColor(.success.highlight)
                    .frame(width: 24, height: 24)
            case .loading:
                ProgressView()
            default:
                if focused && !text.isEmpty && isEnabled {
                    Button(
                        action: { text.removeAll() },
                        label: {
                            Image(.alert)
                                .resizable()
                                .foregroundColor(.text.tertiary)
                                .frame(width: 24, height: 24)
                        }
                    )
                }
            }
        }
    }
}

private struct SecureEditorView: View {
    @Environment(\.isEnabled) var isEnabled
    @FocusState var focused: Bool

    @Binding var text: String
    @State var isRevealed: Bool = false
    let onSubmit: () -> Void
    let prompt: String
    let textColor: Color
    let cursorColor: Color

    var body: some View {
        HStack(spacing: .s) {
            CustomSecureTextField(
                text: $text,
                onSubmit: onSubmit,
                prompt: prompt,
                isRevealed: isRevealed,
                textColor: textColor,
                font: TextStyle.body1.uiFont
            )
            .foregroundColor(textColor)
            .accentColor(cursorColor)
            .focused($focused)

            Button(
                action: {
                    isRevealed = !isRevealed
                },
                label: {
                    Image(isRevealed ? .viewOn : .viewOff)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.text.tertiary)
                }
            )
            .opacity(focused && !text.isEmpty && isEnabled ? 1 : 0)
        }
    }
}

struct CustomSecureTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onSubmit: () -> Void

        init(text: Binding<String>, onSubmit: @escaping () -> Void) {
            _text = text
            self.onSubmit = onSubmit
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textFieldShouldReturn(_: UITextField) -> Bool {
            onSubmit()
            return true
        }
    }

    @Binding var text: String
    let onSubmit: () -> Void
    let prompt: String
    let isRevealed: Bool
    let textColor: Color
    let font: UIFont

    func makeUIView(context: UIViewRepresentableContext<CustomSecureTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = !isRevealed
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.textContentType = .password
        textField.font = font
        textField.placeholder = prompt
        textField.textColor = UIColor(textColor)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.returnKeyType = .done
        return textField
    }

    func makeCoordinator() -> CustomSecureTextField.Coordinator {
        Coordinator(text: $text, onSubmit: onSubmit)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomSecureTextField>) {
        uiView.isSecureTextEntry = !isRevealed
        uiView.text = text
        uiView.placeholder = prompt
    }
}

struct DesignTextField_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            DesignTextField(
                title: "Default",
                prefix: "+36",
                text: .constant("20 3 203 206"),
                prompt: "prompt",
                hint: "Kérem adja meg a telefonszámát!",
                validationState: .normal
            )
            .padding([.leading, .trailing])
            .padding([.bottom], .xs)

            DesignTextField(
                title: "Default",
                text: .constant("text"),
                prompt: "prompt",
                validationState: .error(text: "This is a bad situation")
            )
            .padding([.leading, .trailing])
            .padding([.bottom], .xs)

            DesignTextField(
                title: "Default",
                prefix: "+36",
                suffix: "Ft",
                text: .constant("1201202"),
                prompt: "prompt",
                infoButtonText: "Hol találom?",
                infoButtonTextAction: {},
                infoButtonImageAction: {},
                validationState: .validated
            )
            .viewOnly(true)
            .padding([.leading, .trailing])
            .padding([.bottom], .xs)

            DesignTextField(
                title: "Default",
                text: .constant("text"),
                prompt: "prompt",
                validationState: .loading
            )
            .padding([.leading, .trailing])
            .padding([.bottom], .xs)

            DesignTextField(
                title: "Secured",
                text: .constant(""),
                prompt: "secured",
                editor: .secured(onSubmit: {}),
                validationState: .normal
            )
            .padding([.leading, .trailing])
            .padding([.bottom], .xs)

            DesignTextField(
                title: "Disabled",
                text: .constant("Disabled"),
                validationState: .normal
            )
            .padding([.leading, .trailing])
            .padding([.bottom], .xs)
            .disabled(true)
            .preferredColorScheme(.light)

            DesignTextField(
                title: "Prefix imaged - view Only",
                prefixImage: Image(systemName: "magnifyingglass"),
                text: .constant("This is the text"),
                prompt: "Search",
                validationState: .normal
            )
            .viewOnly(true)
            .padding([.leading, .trailing])
        }
    }
}

public struct DesignTextFieldHeader: View {
    let title: String
    let infoButtonText: String
    let infoButtonTextAction: () -> Void
    let infoButtonImageAction: (() -> Void)?

    public init(
        title: String = "",
        infoButtonText: String = "",
        infoButtonTextAction: @escaping () -> Void = {},
        infoButtonImageAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.infoButtonText = infoButtonText
        self.infoButtonTextAction = infoButtonTextAction
        self.infoButtonImageAction = infoButtonImageAction
    }

    public var body: some View {
        HStack(spacing: 6) {
            if !title.isEmpty {
                Text(title)
                    .foregroundColor(.text.secondary)
                    .textStyle(.body2)
                    .frame(height: 20)
                    .padding(.bottom, .xs)
            }
            if let infoButtonImageAction = infoButtonImageAction {
                Button {
                    infoButtonImageAction()
                } label: {
                    Image(.info)
                        .resizable()
                        .frame(width: .l, height: .l)
                        .padding(.bottom, .xs)
                        .foregroundColor(.text.tertiary)
                }
            }
            if !infoButtonText.isEmpty {
                Spacer()
                Button(infoButtonText) {
                    infoButtonTextAction()
                }
                .buttonStyle(DesignHighlight(style: .tertiary))
                .padding(.bottom, .xs)
                .textStyle(.headings6)
                .foregroundColor(.highlight.tertiary)
            }
        }
    }
}
