//
//  PasswordCreationScreen.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import Combine
import DesignKit
import Foundation
import SwiftUI

protocol PasswordCreationScreenViewModelProtocol: ObservableObject {
    var password: String { get set }
    var criterias: [Criteria] { get }
    var passwordFieldState: ValidationState { get }
    var resultModel: ResultModel? { get }
    var isLoading: Bool { get }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }

    func handle(action: PasswordCreationScreenInput)
}

enum PasswordCreationScreenInput {
    case passwordEntered
}

struct PasswordCreationScreen<ViewModel: PasswordCreationScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState var focused: Bool
    @State var isTextChanged: Bool = false

    var body: some View {
        FormLayout {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Spacer()
                    CreatePasswordtStaticView()
                    Card {
                        CriteriaView(
                            criterias: viewModel.criterias,
                            isEditingPassword: focused || !isTextChanged
                        )
                    }
                    .padding([.top], .xl)
                    DesignTextField(
                        title: Strings.Localizable.createPasswordInputTitle,
                        text: $viewModel.password,
                        editor: .secured(onSubmit: {
                            if viewModel.passwordFieldState == .validated {
                                viewModel.handle(action: .passwordEntered)
                            } else {
                                hideKeyboard()
                            }
                        }),
                        validationState: viewModel.passwordFieldState
                    )
                    .hideErrorWhileEditing(true)
                    .hideErrorBeforeEditing(true)
                    .disabled(viewModel.isLoading)
                    .padding([.top], .m)
                    .focused($focused)
                    .onSubmit { focused = false }
                    .onAppear(after: 0.6) {
                        focused = true
                    }
                    .onChange(of: viewModel.password) { _ in
                        isTextChanged = true
                    }
                    Spacer()
                }
                .padding(.horizontal, .m)
            }
            .padding(.horizontal, .m)
        } floater: {
            Group {
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .highlight.primary.background))
                            .scaleEffect(1.3)
                        Spacer()
                    }
                } else {
                    DesignButton(
                        style: .primary,
                        title: Strings.Localizable.createPasswordButtonTitle,
                        action: { viewModel.handle(action: .passwordEntered) }
                    )
                    .disabled(viewModel.passwordFieldState != .validated)
                }
            }
            .frame(height: 60)
        }
        .onTapGesture { hideKeyboard() }
        .background(Color.background.secondary)
        .fullscreenResult(model: viewModel.resultModel)
        .designAlert(viewModel.bottomAlert)
        .animation(.fast, value: focused)
        .animation(.default, value: viewModel.isLoading)
        .analyticsScreenView("registration_set_password")
    }
}

private class MockViewModel: PasswordCreationScreenViewModelProtocol {
    var bottomAlert = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()
    var resultModel: ResultModel?
    var isLoading: Bool = true
    var password: String = "Aba123"
    var criterias: [Criteria] = [
        .init(title: "Kisbetű", fulfilled: false),
        .init(title: "Nagybetű", fulfilled: true),
        .init(title: "Szám", fulfilled: true),
        .init(title: "Legalább 3 karakter", fulfilled: true)
    ]

    func handle(action: PasswordCreationScreenInput) {}
    var passwordFieldState: ValidationState = .normal
}

struct CreatePasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            PasswordCreationScreen(viewModel: MockViewModel())
                .preferredColorScheme(.light)
        }
    }
}
