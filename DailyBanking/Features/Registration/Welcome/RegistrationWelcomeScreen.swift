//
//  RegistrationWelcomeScreen.swift
//  app-daily-banking-ios
//
//  Created by Zsombor Szabó on 2021. 10. 05..
//

import DesignKit
import SwiftUI

protocol RegistrationWelcomeScreenViewModelProtocol: ObservableObject {
    var greetingsText: String { get }
    func handle(event: RegistrationWelcomeScreenInput)
}

enum RegistrationWelcomeScreenInput {
    case login
    case registration
}

struct RegistrationWelcomeScreen<ViewModel: RegistrationWelcomeScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Image(.brandSymbol)
                    .resizable()
                    .frame(width: 112, height: 112, alignment: .center)
                Text(viewModel.greetingsText)
                    .textStyle(.headings3.thin)
                    .padding(.top, .xl)
                    .foregroundColor(.text.primary)
                Text(Strings.Localizable.startDescription)
                    .multilineTextAlignment(.center)
                    .textStyle(.body1)
                    .padding(.top, .xs)
                    .foregroundColor(.text.tertiary)
            }
            .padding([.leading, .trailing], .xxxl)
            Spacer()
            VStack(spacing: 0) {
                DesignButton(
                    style: .primary,
                    size: .large,
                    title: Strings.Localizable.startRegistration,
                    action: {
                        viewModel.handle(event: .registration)
                    })
                .padding(.vertical, .m)
                DesignButton(
                    style: .tertiary,
                    size: .large,
                    title: Strings.Localizable.startDeviceActivation,
                    action: {
                        viewModel.handle(event: .login)
                    })
            }
            .paddingFloating()
        }
        .background(Color.background.secondary)
        .analyticsScreenView("start")
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationWelcomeScreen(viewModel: MockLoginViewModel())
    }
}

class MockLoginViewModel: RegistrationWelcomeScreenViewModelProtocol {
    var greetingsText: String = "Jó napot!"
    func handle(event: RegistrationWelcomeScreenInput) {}
}
