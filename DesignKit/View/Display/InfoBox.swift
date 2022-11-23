//
//  InfoBox.swift
//  DesignKit
//
//  Created by Márk József Alexa on 2022. 01. 24..
//

import SwiftUI

public struct InfoBox: View {
    let cornerRadius: CGFloat
    let status: Status
    let image: Image
    let title: String
    let subtitle: String
    let actionTitle: String
    let action: (() -> Void)?
    let closeAction: (() -> Void)?

    public init(
        cornerRadius: CGFloat = .l,
        status: Status,
        image: Image,
        title: String,
        subtitle: String,
        actionTitle: String = "",
        action: (() -> Void)? = nil,
        closeAction: (() -> Void)? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.status = status
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
        self.closeAction = closeAction
    }

    public var body: some View {
        VStack {
            HStack(spacing: .m) {
                image
                    .resizable()
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: .xxs) {
                    HStack(alignment: .top) {
                        Text(title)
                            .textStyle(.headings5)
                            .foregroundColor(status.titleColor)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        if let closeAction = closeAction {
                            Image(.close)
                                .foregroundColor(.text.tertiary)
                                .frame(width: .xxxl, height: .xxxl)
                                .onTapGesture { closeAction() }
                        }
                    }
                    HStack {
                        Text(subtitle)
                            .textStyle(.body2)
                            .foregroundColor(.text.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.s)
            if let action = action {
                DesignButton(style: .primary, title: actionTitle) {
                    action()
                }
                .padding(.horizontal, .s)
                .padding(.bottom, .s)
            }
        }
        .background(Color.background.primary)
        .cornerRadius(cornerRadius)
    }

    public enum Status {
        case warning, error, success, info

        var titleColor: Color {
            switch self {
            case .warning: return .warning.highlight
            case .error: return .error.highlight
            case .success: return .success.highlight
            case .info: return .info.highlight
            }
        }
    }
}

struct InfoBox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background.secondary
                .ignoresSafeArea()
            VStack(spacing: .s) {
                InfoBox(
                    status: .error,
                    image: Image(.help),
                    title: "Elkészült az új virtuális kártyája.",
                    subtitle: "Adja hozzá az Apple Wallethez, és frissítse a bankkártyaszámát az előfizetéseinél!",
                    actionTitle: "Rendben") {} closeAction: {}
                InfoBox(
                    status: .warning,
                    image: Image(.help),
                    title: "Elkészült az új virtuális kártyája.",
                    subtitle: "Adja hozzá az Apple Wallethez, és frissítse a bankkártyaszámát az előfizetéseinél!")
                InfoBox(
                    status: .info,
                    image: Image(.help),
                    title: "Elkészült az új virtuális kártyája.",
                    subtitle: "Adja hozzá az Apple Wallethez, és frissítse a bankkártyaszámát az előfizetéseinél!",
                    closeAction: {})
                InfoBox(
                    status: .success,
                    image: Image(.help),
                    title: "Elkészült az új virtuális kártyája.",
                    subtitle: "Adja hozzá az Apple Wallethez, és frissítse a bankkártyaszámát az előfizetéseinél!")
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}
