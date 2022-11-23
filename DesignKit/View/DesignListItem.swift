//
//  DesignListItem.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import SwiftUI

public struct DesignListItem: View {
    @Environment(\.redactionReasons) var redactionReasons

    let leftView: AnyView?
    let title: String
    let subtitle: String?
    let rightView: AnyView?
    let action: (() -> Void)?

    public init(
        leftView: AnyView? = nil,
        title: String,
        subtitle: String? = nil,
        rightView: AnyView? = nil,
        action: (() -> Void)? = nil
    ) {
        self.leftView = leftView
        self.title = title
        self.subtitle = subtitle
        self.rightView = rightView
        self.action = action
    }

    public var body: some View {
        if let action = action {
            Button(action: {
                action()
            }, label: {
                content
            })
            .buttonStyle(ThemedButtonStyle())
        } else {
            content
        }
    }

    var content: some View {
        HStack(alignment: .center, spacing: 0) {
            if let leftView = leftView {
                if redactionReasons.isEmpty {
                    leftView
                } else {
                    Circle()
                        .frame(width: 36, height: 36)
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.body2)
                    .foregroundColor(Color.defaultPrimaryText)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.body3)
                        .foregroundColor(Color.defaultSecondaryText)
                }
            }
            .padding(.leading, .xs)
            .padding(.trailing, 0)
            Spacer()
            if let rightView = rightView {
                rightView
            }
        }
        .padding(.s)
    }

    func image(_ name: ImageName) -> some View {
        Image(name)

    }
}

private struct ThemedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed ? Color.highlightedTertiary : Color.defaultBackgroundAlt
            )
    }
}

struct DesignListItemPreviews: PreviewProvider {
    static var previews: some View {
        DesignListItem(
            leftView: AnyView(Image(.info).resizable().frame(width: 36, height: 36)),
            title: "Relative Long title, more title here, end",
            subtitle: "Relative long subtitle",
            rightView: AnyView(Text("99 999")),
            action: {})
    }
}
