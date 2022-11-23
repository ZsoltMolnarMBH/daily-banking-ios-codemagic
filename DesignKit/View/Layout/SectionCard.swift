//
//  SectionCard.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 01. 02..
//

import SwiftUI

public struct SectionCard<Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    public init(alignment: HorizontalAlignment = .leading,
                spacing: CGFloat = 0,
                @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        Card {
            HStack {
                VStack(alignment: alignment, spacing: spacing) {
                    content()
                }
                Spacer(minLength: 0)
            }
        }
    }
}

struct SectionCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            SectionCard {
                Text("Hello content")
                HStack {
                    Text("Hello content")
                    Spacer()
                    Text("Hello content")
                }
                Text("Hello content")
            }
            Spacer()
        }
        .background(Color.background.secondary)
    }
}
