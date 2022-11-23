//
//  BiometrySetupScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 10..
//

import DesignKit
import SwiftUI
import LocalAuthentication

protocol BiometrySetupScreenViewModelProtocol: ObservableObject {

    var isBiometryAvailable: Bool { get }
    var biometryImage: ImageName { get }
    var title: String { get }
    var message: String { get }
    var subtitle: String { get }
    var multiBiomentricHelpButtonTitle: String { get }
    var analyticsName: String { get }
    var alert: AlertModel? { get set }

    func handle(event: BiometrySetupScreenInputs)
}

enum BiometrySetupScreenInputs {
    case start
    case skip
    case goSettings
    case generalHelp
    case multpleBiometricHelp
}

struct BiometrySetupScreen<ViewModel: BiometrySetupScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Group {
            if viewModel.isBiometryAvailable {
                BiometryEnabledView(viewModel: viewModel)
            } else {
                BiometryDisabledView(viewModel: viewModel)
            }
        }
        .background(Color.background.secondary)
        .analyticsScreenView(viewModel.analyticsName)
    }
}

private struct BiometryEnabledView<ViewModel: BiometrySetupScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        InfoScreen(model: .init(
            images: [viewModel.biometryImage],
            title: viewModel.title,
            messages: [
                viewModel.message,
                viewModel.subtitle
            ],
            messageButtons: [
                .init(text: viewModel.multiBiomentricHelpButtonTitle,
                      style: .tertiary, action: { viewModel.handle(event: .multpleBiometricHelp) })
            ],
            buttons: [
                .init(text: Strings.Localizable.commonEnable,
                      style: .primary,
                      action: { viewModel.handle(event: .start) }),
                .init(text: Strings.Localizable.commonSkip,
                      style: .tertiary,
                      action: { viewModel.handle(event: .skip) })
            ])
        )
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                DesignButton(
                    style: .tertiary,
                    width: .fluid,
                    imageName: DesignKit.ImageName.info,
                    action: {
                        viewModel.handle(event: .generalHelp)
                    })
                    .analyticsOverride(contentType: "info icon")
            }
        })
        .alert(alertModel: $viewModel.alert)
    }
}

private struct BiometryDisabledView<ViewModel: BiometrySetupScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        InfoScreen(model: .init(
            images: [.smartphoneRegistration],
            title: Strings.Localizable.biometrySetupTitle,
            messages: [
                Strings.Localizable.biometrySetupSubtitle
            ],
            messageButtons: [
                .init(text: Strings.Localizable.biometrySetupInfoTitle,
                      style: .tertiary,
                      action: { viewModel.handle(event: .generalHelp) })
            ],
            buttons: [
                .init(text: Strings.Localizable.commonTurnOn,
                      style: .primary,
                      action: { viewModel.handle(event: .goSettings) }),
                .init(text: Strings.Localizable.commonSkip,
                      style: .tertiary,
                      action: { viewModel.handle(event: .skip) })
            ])
        )
    }
}

private class MockViewModel: BiometrySetupScreenViewModelProtocol {
    var analyticsName: String = ""
    var isBiometryAvailable: Bool = true
    var title: String = "Engedélyezi a Face ID-t?"
    var message: String = "Ha engedélyezi, arcfelismeréssel is beléphet az appba és jóváhagyhatja a tranzakciókat."
    var subtitle: String = "A Face ID-t később is engedélyezheti."
    var multiBiomentricHelpButtonTitle: String = "Mi történik, ha mások arca is be van állítva a készüléken?"

    var biometryImage: ImageName = .faceid
    var alert: AlertModel?

    func handle(event: BiometrySetupScreenInputs) {}
}

struct BiometrySetupScreenPreview: PreviewProvider {
    static var previews: some View {
        Group {
            BiometrySetupScreen(viewModel: MockViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
