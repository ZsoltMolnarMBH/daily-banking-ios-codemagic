//
//  NFCPositionInfoScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 17..
//

import DesignKit
import SwiftUI

struct NFCPositionInfoScreen: View {
    let onAck: () -> Void

    var body: some View {
        FormLayout {
            VStack(alignment: .leading, spacing: .m) {
                Text(Strings.Localizable.kycEidHelpActionTitle)
                    .textStyle(.headings4)
                    .foregroundColor(.text.secondary)
                Text(Strings.Localizable.kycEidHelpDescriptionIos)
                    .textStyle(.body1)
                    .foregroundColor(.text.secondary)
            }
            .padding(.m)
            Spacer()
        } floater: {
            DesignButton(
                style: .primary,
                title: Strings.Localizable.commonAllRight,
                action: {
                    onAck()
                }
            )
        }
    }
}

struct NFCPositionInfoScreenPreviews: PreviewProvider {
    static var previews: some View {
        NFCPositionInfoScreen(onAck: {})
    }
}
