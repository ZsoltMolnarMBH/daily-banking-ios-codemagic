//
//  SelectButtonView.swift
//  DesignKit
//
//  Created by Márk József Alexa on 2022. 01. 04..
//

import SwiftUI

public struct DropDownListButton: View {
    let title: String
    let text: String
    let state: ValidationState
    let action: () -> Void

    private let cornerRadius: CGFloat = 10
    private let height: CGFloat = 48

    public init(
        title: String = "",
        text: String = "",
        validationState: ValidationState = .normal,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.text = text
        self.state = validationState
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !title.isEmpty {
                Text(title)
                    .foregroundColor(.text.secondary)
                    .textStyle(.body2)
                    .frame(height: 20)
                    .padding(.bottom, .xs)
            }
            ZStack {
                backgroundWithBorder
                HStack {
                    Text(text)
                        .textStyle(.body1)
                        .foregroundColor(.text.primary)
                        .padding(.xs)
                    Spacer()
                    Image(.chevronDown)
                        .padding(.horizontal)
                }
            }
            .onTapGesture {
                action()
            }
            if case .error(let errorMessage) = state {
                errorView(with: errorMessage)
            }
        }
    }

    var backgroundWithBorder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.background.primary)
                .frame(height: height)

            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: 2)
                .foregroundColor(borderColor)
                .frame(height: height)
        }
    }

    var borderColor: Color {
        if case .error = state {
            return .error.highlight
        } else {
            return .element.tertiary
        }
    }

    @ViewBuilder func errorView(with errorText: String) -> some View {
        Text(errorText)
            .textStyle(.body2)
            .foregroundColor(.error.highlight)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .frame(height: 28)
            .padding(.top, .m)
    }
}

struct DropDownListButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .xxxl) {
            DropDownListButton(title: "Havont kb mekkora összeget?", text: "Kérjük válasszon!") {}
            DropDownListButton(text: "Kérjük válasszon!") {}
        }
        .padding()
    }
}
