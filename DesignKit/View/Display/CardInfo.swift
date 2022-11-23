//
//  CardInfo.swift
//  DesignKit
//
//  Created by Alexa Mark on 2021. 11. 12..
//

import SwiftUI

public struct CardInfo: View {
    let cornerRadius: CGFloat
    let title: String
    let subtitle: String
    let infoAction: (() -> Void)?

    public init(
        cornerRadius: CGFloat = .l,
        title: String,
        subtitle: String,
        infoAction: (() -> Void)? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.title = title
        self.subtitle = subtitle
        self.infoAction = infoAction
    }

    public var body: some View {
        HStack {
            InfoView(title: title, text: subtitle)
            if let infoAction = infoAction {
                Button(action: infoAction) {
                    Image(.info)
                        .foregroundColor(Color.text.tertiary)
                }
            }
        }
        .padding(.horizontal, .m)
        .padding(.vertical, .s)
        .background(Color.background.primaryDisabled)
        .cornerRadius(cornerRadius)
    }
}

struct CardInfo_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CardInfo(
                title: "Telefonszám",
                subtitle: "+36 20 0001 000",
                infoAction: {}
            )
            CardInfo(
                title: "Telefonszám",
                subtitle: "+36 20 0001 000"
            )
        }
        .preferredColorScheme(.light)
    }
}
