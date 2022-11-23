//
//  FullHeightScrollView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import Foundation
import SwiftUI

public struct FullHeightScrollView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                content().frame(minHeight: geometry.size.height)
            }
        }
    }
}
