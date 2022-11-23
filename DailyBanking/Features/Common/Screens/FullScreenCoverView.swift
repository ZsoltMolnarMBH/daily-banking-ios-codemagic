//
//  FullScreenCoverView.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 02..
//

import Foundation
import SwiftUI

struct FullScreenCoverView: View {
    var body: some View {
        Color.clear
            .ignoresSafeArea()
            .background(.ultraThinMaterial)
    }
}

struct FullScreenCoverPreview: PreviewProvider {
    static var previews: some View {
        Group {
            FullScreenCoverView()
                .preferredColorScheme(.light)
            FullScreenCoverView()
                .preferredColorScheme(.dark)
        }
    }
}
