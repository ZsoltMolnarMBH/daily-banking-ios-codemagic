//
//  PinCreationInfoDialog.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 27..
//

import DesignKit
import SwiftUI

enum PinType {
    case mPin
    case cardPin

    var title: String {
        switch self {
        case .mPin:
            return Strings.Localizable.pinInfoHint
        case .cardPin:
            return Strings.Localizable.pinSetupInfoHint
        }
    }

    var description: String {
        switch self {
        case .mPin:
            return Strings.Localizable.pinTipsDescription
        case .cardPin:
            return Strings.Localizable.pinSetupTipsDescription
        }
    }
}

struct PinCreationInfoDialog: View {

    var pinType: PinType = .mPin

    var onDismiss: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: .xxs) {
            HStack {
                Spacer()
                Image(.passwordLockDuotone)
                    .resizable()
                    .frame(width: 72, height: 72)
                    .padding(.bottom, .m)
                Spacer()
            }
            HStack {
                Spacer()
                Text(pinType.title)
                    .textStyle(.headings4)
                    .foregroundColor(.text.primary)
                    .padding(.bottom, .s)
                Spacer()
            }

            Text(pinType.description)
                .textStyle(.body2.condensed)
                .foregroundColor(.text.secondary)
                .padding(.bottom, .xxxl)

            DesignButton(
                style: .secondary,
                title: Strings.Localizable.commonClose,
                action: {
                    onDismiss?()
                })
        }
        .padding(.horizontal, .m)
        .padding(.top, .xl)
        .padding(.bottom, .s)
        .background(Color.background.primary)
        .cornerRadius(20)
    }
}

struct PinCreationPreviews: PreviewProvider {
    static var previews: some View {
        PinCreationInfoDialog()
    }
}
