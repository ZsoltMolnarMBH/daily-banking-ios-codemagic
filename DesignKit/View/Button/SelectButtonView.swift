//
//  SelectButtonView.swift
//  DesignKit
//
//  Created by Márk József Alexa on 2022. 01. 04..
//

import SwiftUI

public struct SelectButtonView: View {
    let title: String
    let text: String
    let action: () -> Void

    private let cornerRadius: CGFloat = 10
    private let height: CGFloat = 48

    public init(
        title: String = "",
        text: String = "",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.text = text
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
                        .foregroundColor(.text.tertiary)
                        .padding()
                    Spacer()
                    Image(.chevronDown)
                        .padding()
                }
            }
            .onTapGesture {
                action()
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
                .foregroundColor(.element.tertiary)
                .frame(height: height)
        }
    }
}

struct SelectButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .xxxl) {
            SelectButtonView(title: "Havont kb mekkora söseget?", text: "Kérjük válasszon!") {}
            SelectButtonView(text: "Kérjük válasszon!") {}
        }
        .padding()
    }
}
