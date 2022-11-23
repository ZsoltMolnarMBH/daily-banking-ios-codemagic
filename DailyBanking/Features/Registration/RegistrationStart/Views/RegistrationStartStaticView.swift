//
//  RegistrationStartStaticView.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import Foundation
import SwiftUI

struct RegistrationStartStaticView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(.smartphoneRegistration)
                .resizable()
                .frame(width: 72, height: 72)
            Text(Strings.Localizable.registrationStartTitle)
                .textStyle(.headings3.thin)
                .foregroundColor(.text.primary)
                .multilineTextAlignment(.center)
                .padding([.top], .xl)
        }
    }
}

struct RegistrationStartStaticView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationStartStaticView()
    }
}

struct RegistrationStartStaticViewDark_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationStartStaticView().preferredColorScheme(.dark)
    }
}
