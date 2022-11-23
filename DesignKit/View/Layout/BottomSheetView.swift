//
//  BottomSheetView.swift
//  DesignKit
//
//  Created by Márk József Alexa on 2021. 12. 14..
//

import SwiftUI

public struct BottomSheetView<Content: View>: View {
    let cornerRadius: CGFloat
    let backgroundColor: Color
    @ViewBuilder let content: () -> Content

    public init(
        cornerRadius: CGFloat = .l,
        backgroundColor: Color = .background.secondary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .xs) {
            HStack {
                Spacer()
                BottomSheetIndicator()
                Spacer()
            }
            content()
        }
        .padding(.top, .xs)
        .padding(.bottom, 100)
        .padding(.horizontal, .m)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}

private struct BottomSheetIndicator: View {
    public var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.secondary)
            .frame(width: 32, height: 4)
            .foregroundColor(.background.primaryDisabled)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView {
            Text("Mizu van?")
                .padding()
        }
    }
}
