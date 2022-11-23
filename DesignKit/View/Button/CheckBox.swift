//
//  CheckBox.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 21..
//

import SwiftUI

public struct CheckBox: View {
    private let size: CGFloat = 32
    private let cornerRadius: CGFloat = 10

    @Environment(\.isEnabled) var isEnabled
    @Binding var isChecked: Bool

    public init(isChecked: Binding<Bool>) {
        self._isChecked = isChecked
    }

    public var body: some View {
        Button(
            action: {
                isChecked = !isChecked
            },
            label: {
                ZStack {
                    backgroundColor
                        .frame(width: size, height: size)
                        .cornerRadius(cornerRadius)

                    if isEnabled {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.element.tertiary)
                            .frame(width: size, height: size)
                    }

                    if isChecked {
                        Group {
                            checkedColor
                                .frame(width: size, height: size)
                                .cornerRadius(cornerRadius)

                            Image(.check)
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(checkmarkColor)
                        }
                    }
                }
        })
    }

    var backgroundColor: Color {
        if isEnabled {
            return .element.primary.foreground
        } else {
            return .background.primaryDisabled
        }
    }

    var checkedColor: Color {
        if isEnabled {
            return .highlight.tertiary
        } else {
            return .background.primaryDisabled
        }
    }

    var checkmarkColor: Color {
        if isEnabled {
            return .background.secondary
        } else {
            return .text.disabled
        }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CheckBox(isChecked: .constant(false))
            .padding()

            CheckBox(isChecked: .constant(true))
            .disabled(true)
            .padding()

            CheckBox(isChecked: .constant(false))
            .padding()

            CheckBox(isChecked: .constant(true))
            .padding()
        }.preferredColorScheme(.dark)
    }

}
