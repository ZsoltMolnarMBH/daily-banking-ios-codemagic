//
//  CreatePasswordStaticView.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import Foundation
import SwiftUI

struct CreatePasswordtStaticView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(.shieldLocked)
                .resizable()
                .frame(width: 72, height: 72)
            Text(Strings.Localizable.createPasswordTitle)
                .foregroundColor(.text.primary)
                .padding([.top], .xl)
                .textStyle(.headings3.thin)
            Text(Strings.Localizable.createPasswordSubtitle)
                .foregroundColor(.text.secondary)
                .multilineTextAlignment(.center)
                .padding([.top], .xs)
                .textStyle(.body1)
        }
    }
}

struct CreatePasswordtStaticView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordtStaticView()
    }
}

struct CreatePasswordtStaticViewDark_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordtStaticView().preferredColorScheme(.dark)
    }
}
