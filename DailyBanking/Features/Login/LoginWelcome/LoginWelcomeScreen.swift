//
//  LoginWelcomeScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import DesignKit
import SwiftUI

enum LoginWelcomeScreenInput {
    case login
}

protocol LoginWelcomeScreenViewModelProtocol: ObservableObject {
    var initials: String { get }
    var welcomeMessage: String { get }

    func handle(_ event: LoginWelcomeScreenInput)
}

struct LoginWelcomeScreen<ViewModel: LoginWelcomeScreenViewModelProtocol>: View {

    let viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Group {
                MonogramView(
                    monogram: viewModel.initials,
                    size: .large
                ).padding(.bottom, .m)

                Text(viewModel.welcomeMessage)
                    .textStyle(.headings3.thin)
                    .foregroundColor(Color.text.primary)
            }
            .padding(.horizontal, .m)
            Spacer()

            DesignButton(
                style: .primary,
                title: Strings.Localizable.loginButton,
                action: {
                    viewModel.handle(.login)
                }
            )
            .paddingFloating()
        }
        .background(Color.background.secondary)
        .analyticsScreenView("login_start")
    }
}

struct LoginWelcomePreviews: PreviewProvider {
    static var previews: some View {
        LoginWelcomeScreen(viewModel: MockViewModel())
    }
}

private class MockViewModel: LoginWelcomeScreenViewModelProtocol {
    @Published var initials: String = "IZ"
    @Published var welcomeMessage: String = "Szép estét, Zsolt!"

    func handle(_ event: LoginWelcomeScreenInput) {}
}
