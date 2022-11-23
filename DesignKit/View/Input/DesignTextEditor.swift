//
//  DesignTextView.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 01. 25..
//

import SwiftUI

public struct DesignTextEditor: TrimmedTextInput {
    // MARK: Constants
    private let cornerRadius: CGFloat = 10

    // MARK: Given propeties
    let title: String
    let titleHint: String?
    let maxCharacterCount: Int?
    let fixedHeight: CGFloat
    let text: Binding<String>
    let characterCounter: (String) -> Int

    // MARK: TextInputCommon
    @Environment(\.isEnabled) public var isEnabled
    public var isViewOnly: Bool = false
    public var viewOnlyTapAction: (() -> Void)?
    public let state: ValidationState
    @FocusState public var focused: Bool
    @State public var isAlreadyEdited = false
    @State var showError: Bool = false
    public var isHidingErrorWhileEditing = false
    public var isHidingErrorBeforeEditing = false
    public var onReturn: (() -> Void)?
    public var resignOnReturn = false
    public var returnKeyType: UIReturnKeyType = .done
    public var trimmedCharacters: CharacterSet? = .whitespaces

    public static let defaultCharacterCounter: (String) -> Int = { $0.count }

    public init(title: String,
                titleHint: String? = nil,
                state: ValidationState = .normal,
                maxCharacterCount: Int?,
                fixedHeight: CGFloat,
                text: Binding<String>,
                characterCounter: @escaping (String) -> Int = Self.defaultCharacterCounter) {
        self.title = title
        self.titleHint = titleHint
        self.state = state
        self.maxCharacterCount = maxCharacterCount
        self.fixedHeight = fixedHeight
        self.text = text
        self.characterCounter = characterCounter
        UITextView.appearance().backgroundColor = .clear
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .xs) {
            HStack(spacing: .xxs) {
                Text(title)
                    .textStyle(.body2)
                    .foregroundColor(.text.secondary)
                if let titleHint = titleHint {
                    Text(titleHint)
                        .textStyle(.body2)
                        .foregroundColor(.text.tertiary)
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 2)
                    .foregroundColor(borderColor)
                TextView(text: textBinding,
                         onReturn: onReturn,
                         resignOnReturn: resignOnReturn,
                         configuration: { view in
                    view.returnKeyType = self.returnKeyType
                    view.font = TextStyle.body1.uiFont
                    view.textColor = UIColor(.text.primary)
                    view.tintColor = UIColor(.highlight.tertiary)
                })
                .focused($focused)
                .padding(.s)
                .onChange(of: text.wrappedValue) { newValue in
                    if !newValue.isEmpty {
                        isAlreadyEdited = true
                    }
                }
                .onChange(of: focused) { _ in
                    trim(text: text)
                }
                .disabled(isViewOnly)
            }
            .frame(height: fixedHeight)

            if showError {
                errorView()
            }

            if let maxCharacterCount = maxCharacterCount {
                HStack {
                    Spacer()
                    Text("\(characterCounter(text.wrappedValue))/\(maxCharacterCount)")
                        .textStyle(.body2)
                        .foregroundColor(.text.tertiary)
                }
            }
        }
        .onChange(of: isErrorViewVisible) { value in
            withAnimation { showError = value }
        }
        .onTapGesture { /* consume touch events - avoid passthrough touch while editing */ }
    }

    private var textBinding: Binding<String> {
        if let maxCharacterCount = maxCharacterCount {
            return text.limited(count: maxCharacterCount, escapingCounter: characterCounter)
        } else {
            return text
        }
    }
}

public extension DesignTextEditor {
    func returnKeyType(_ value: UIReturnKeyType) -> Self {
        var view = self
        view.returnKeyType = value
        return view
    }

    func onReturn(_ handler: @escaping () -> Void) -> Self {
        var view = self
        view.onReturn = handler
        return view
    }

    func resignOnReturn(_ resignOnReturn: Bool) -> Self {
        var view = self
        view.resignOnReturn = resignOnReturn
        return view
    }
}

private extension Binding where Value == String {
    func limited(count: Int) -> Self {
        Binding(get: { String(self.wrappedValue.prefix(count)) },
                set: { newValue in
                    self.wrappedValue = String(newValue.prefix(count))
                })
    }

    func limited(count: Int, escapingCounter: @escaping (String) -> Int) -> Self {
        Binding(get: { String(self.wrappedValue.prefix(count)) },
                set: { newValue in
            let segments = newValue.map { character -> (Character, Int) in
                let escapedLength = escapingCounter(String(character))
                return (character, escapedLength)
            }
            var limitedString = ""
            var totalEscapedLenght = 0
            for (character, escapedLength) in segments {
                let newLength = totalEscapedLenght + escapedLength
                if newLength <= count {
                    limitedString.append(character)
                    totalEscapedLenght = newLength
                } else {
                    break
                }
            }
            self.wrappedValue = limitedString
        })
    }
}

struct DesignTextView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                DesignTextEditor(title: "Transfer notice",
                                 titleHint: "(optional)",
                                 maxCharacterCount: 140,
                                 fixedHeight: 120,
                                 text: .constant("Thanks for lunch"))
                DesignTextEditor(title: "Transfer notice",
                                 state: .error(text: "Hello nice error :("),
                                 maxCharacterCount: 140,
                                 fixedHeight: 120,
                                 text: .constant("Thanks for lunch again"))
            }
        }
        .background(Color.background.primary)
        .preferredColorScheme(.dark)
    }
}

struct TextView: UIViewRepresentable {
    typealias UIViewType = UITextView
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        var onReturn: (() -> Void)?
        var resignOnReturn = false

        init(text: Binding<String>, onReturn: (() -> Void)?, resignOnReturn: Bool) {
            _text = text
            self.onReturn = onReturn
            self.resignOnReturn = resignOnReturn
        }

        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                onReturn?()
                if resignOnReturn {
                    textView.endEditing(true)
                    return false
                }
            }
            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onReturn: onReturn, resignOnReturn: resignOnReturn)
    }

    @Binding var text: String
    let onReturn: (() -> Void)?
    var resignOnReturn: Bool
    var configuration: (UIViewType) -> Void = { _ in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        UIViewType()
    }

    func updateUIView(_ view: UIViewType, context: UIViewRepresentableContext<Self>) {
        // Record where the cursor is
        var cursorOffset: Int?
        if let selectedRange = view.selectedTextRange {
            cursorOffset = view.offset(from: view.beginningOfDocument, to: selectedRange.start)
        }

        view.text = text
        view.delegate = context.coordinator
        configuration(view)

        // Put the cursor back
        if let offset = cursorOffset,
            let position = view.position(from: view.beginningOfDocument, offset: offset) {
            view.selectedTextRange = view.textRange(from: position, to: position)
        }
    }
}
