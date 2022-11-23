//
//  RegistrationStartCheckBoxesView.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import DesignKit
import Foundation
import SwiftUI

struct RegistrationStartCheckBoxesView<ViewModel: RegistrationStartScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State var showTermsSheet = false
    @State var showPrivacySheet = false

    var body: some View {
        VStack(spacing: .m) {
            if viewModel.isPhoneNumberCapableForRegistration {
                CheckBoxRow(
                    isChecked: $viewModel.tcAccepted,
                    text: Strings.Localizable.registrationStartTermsMd
                )
                .onLinkTapped { _ in
                    viewModel.handle(event: .tcSelected)
                }
                CheckBoxRow(
                    isChecked: $viewModel.privacyAccepted,
                    text: Strings.Localizable.registrationStartPrivacyMd
                )
                .onLinkTapped { _ in
                    viewModel.handle(event: .privacySelected)
                }
            }
        }
    }
}
