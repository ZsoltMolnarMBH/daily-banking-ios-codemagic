//
//  ChipView.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 01. 13..
//

import SwiftUI

public struct ChipView: View {
    public let text: String
    public let backgroundColor: Color
    public let textColor: Color
    public let size: Size
    public enum Size {
        case small, medium, large
    }

    public init(text: String, backgroundColor: Color, textColor: Color, size: ChipView.Size) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.size = size
    }

    public var body: some View {
        Text(text.uppercased())
            .textStyle(textStyle)
            .foregroundColor(textColor)
            .padding([.vertical], 4)
            .padding([.horizontal], horizontalPadding)
            .background(Capsule().fill(backgroundColor))
    }

    private var textStyle: TextStyle {
        switch size {
        case .small:
            return .headings8
        case .medium:
            return .headings7
        case .large:
            return .headings6
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .small:
            return 6
        case .medium:
            return 8
        case .large:
            return 12
        }
    }
}

struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                ChipView(text: "Default", backgroundColor: Colors.grey100, textColor: Colors.grey800, size: .large)
                ChipView(text: "Default", backgroundColor: Colors.grey100, textColor: Colors.grey800, size: .medium)
                ChipView(text: "Default", backgroundColor: Colors.grey100, textColor: Colors.grey800, size: .small)
            }
        }
    }
}
