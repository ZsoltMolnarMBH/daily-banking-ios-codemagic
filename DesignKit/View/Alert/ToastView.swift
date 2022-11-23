//
//  ToastView.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 03. 24..
//

import Foundation
import SwiftUI

public struct ToastView: View {
    public let text: String
    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(text)
                .textStyle(.body3.condensed)
                .foregroundColor(.element.primary.foreground)
                .padding(.m)

            Spacer()
        }
        .background(Color.element.primary.background)
        .cornerRadius(10)
    }
}

struct ToastViewPreview: PreviewProvider {
    static var previews: some View {
        ToastView(text: "Hello Bello")
    }
}
