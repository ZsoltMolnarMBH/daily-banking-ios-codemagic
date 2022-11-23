//
//  DesignAlertView.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 16..
//

import DesignKit
import SwiftUI

struct DesignAlertView: View {
    let alertModel: AlertModel
    let actionSelected: (() -> Void)

    init(with alertModel: AlertModel, onActionSelected: @escaping () -> Void) {
        self.alertModel = alertModel
        self.actionSelected = onActionSelected
    }

    var body: some View {
        VStack(alignment: .center, spacing: .xxs) {
            if let imageName = alertModel.imageName {
                HStack {
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .frame(width: 72, height: 72)
                        .padding(.vertical, .m)
                    Spacer()
                }
            }
            if let title = alertModel.title {
                Text(title)
                    .multilineTextAlignment(.center)
                    .textStyle(.headings4)
                    .foregroundColor(.text.primary)
                    .padding(.bottom, .xs)
                    .padding(.horizontal, .s)
            }

            if let subtitle = alertModel.subtitle {
                Text(subtitle)
                    .multilineTextAlignment(.center)
                    .textStyle(.body2.condensed)
                    .foregroundColor(.text.secondary)
                    .padding(.bottom, .xs)
                    .padding(.horizontal, .s)
            }

            HStack {
                ForEach(alertModel.actions) { action in
                    DesignButton(
                        style: action.kind == .primary ? .primary : .secondary,
                        size: .large,
                        title: action.title,
                        action: {
                            action.handler()
                            actionSelected()
                        }
                    )
                }
            }
            .padding(.top, .l)
        }
        .padding(.s)
        .background(Color.background.primary)
        .cornerRadius(20)
    }
}

struct DesignAlertViewPreview: PreviewProvider {
    static var previews: some View {
        DesignAlertView(with: .init(
            title: "Elfelejtette az mPin kódját?",
            imageName: .passwordLockDuotone,
            subtitle: "Ahhoz, hogy új mPIN kódot adhasson meg, újra be kell jelentkeznie.",
            actions: [
                .init(title: "Mégsem", kind: .secondary, handler: {}),
                .init(title: "Bejelentkezem", kind: .primary, handler: {})
            ]), onActionSelected: {}
        ).previewDevice(.init(rawValue: "iPhone 7"))
    }
}
