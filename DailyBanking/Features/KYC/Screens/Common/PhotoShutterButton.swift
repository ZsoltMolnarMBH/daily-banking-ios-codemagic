//
//  PhotoShutterButton.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 30..
//

import AVKit
import DesignKit
import SwiftUI

struct PhotoShutterButton: View {
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        ZStack {
            Circle()
                .stroke(style: .init(lineWidth: 8))
                .fill(Color.text.primary)
                .opacity(isLoading ? 0.4 : 1)

            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(
                                tint: Color.text.primary
                            )
                        )
                } else {
                    Button {
                        AudioServicesPlaySystemSound(1108)
                        action()
                    } label: {
                        Circle()
                            .fill(Color.text.secondary)
                    }
                    .hapticOnTouch()
                }
            }
            .frame(width: 56, height: 56, alignment: .center)
        }
        .frame(width: 64, height: 64, alignment: .center)
    }
}
