//
//  IDInfoScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 06. 09..
//

import DesignKit
import SwiftUI

struct IDInfoScreen: View {
    @Environment(\.keyWindowSafeAreaInsets) private var safeArea
    let onAck: () -> Void

    var body: some View {
        ZStack {
            CameraPhotoOverlayView(
                state: .normal,
                shape: .rectangle,
                mode: .instructions(text: Strings.Localizable.kycPrepareYourDocuments, animation: .init(kind: .hint, asset: .idAndAddress)),
                onShutter: {}
            )

            VStack {
                Spacer()
                DesignButton(
                    title: Strings.Localizable.commonNext,
                    action: { onAck() }
                )
                .padding([.leading, .trailing, .top], .m)
                .padding(.bottom, safeArea.bottom > 0 ? 0 : .m)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct IDInfoScreenPreviews: PreviewProvider {
    static var previews: some View {
        IDInfoScreen(onAck: {})
            .previewDevice("iPhone 12")

        IDInfoScreen(onAck: {})
            .previewDevice("iPhone 8")
    }
}
