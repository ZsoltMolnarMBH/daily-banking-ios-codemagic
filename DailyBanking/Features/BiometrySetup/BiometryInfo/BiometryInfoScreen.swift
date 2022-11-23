//
//  BiometryInfoScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 10..
//

import SwiftUI
import DesignKit

struct BiometryInfoScreen: View {
    var onClose: () -> Void

    var body: some View {
        InfoScreen(model: .init(
            images: [.touchId, .faceid],
            title: Strings.Localizable.biometrySetupInfoButtonText,
            imageOrientation: .horizontal,
            messages: [
                Strings.Localizable.biometrySetupInfoSubtitle1Ios,
                Strings.Localizable.biometrySetupInfoSubtitle2Ios,
                Strings.Localizable.biometrySetupInfoSubtitle3
            ],
            messageButtons: [],
            buttons: [
                .init(text: Strings.Localizable.commonAllRight,
                      style: .primary,
                      action: onClose)
            ]))
    }
}

struct BiometryInfoScreenPreview: PreviewProvider {
    static var previews: some View {
        BiometryInfoScreen(onClose: {})
    }
}
