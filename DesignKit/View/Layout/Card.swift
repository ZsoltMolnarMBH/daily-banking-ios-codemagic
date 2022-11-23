//
//  Card.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import SwiftUI

public struct Card<Content: View>: View {
    let cornerRadius: CGFloat
    let padding: CGFloat
    @ViewBuilder let content: () -> Content

    public init(
        cornerRadius: CGFloat = .l,
        padding: CGFloat = .m,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            content()
                .padding(padding)
        }
        .background(Color.background.primary)
        .cornerRadius(cornerRadius)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background.secondary.edgesIgnoringSafeArea(.all)
            Card {
                Text("Hello - bello")
                    .padding()
            }
        }
    }
}
