//
//  BiometryUnavailableScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 14..
//

import Foundation
import SwiftUI
import DesignKit

protocol BiometryUnavailableScreenViewModelProtocol: ObservableObject {
    var imageName: ImageName { get }
    var title: String { get }

    func handle(_ event: BiometryUnavailableScreenInput)
}

enum BiometryUnavailableScreenInput {
    case help
    case openSettings
}

struct BiometryUnavailableScreen<ViewModel: BiometryUnavailableScreenViewModelProtocol>: View {
    let viewModel: ViewModel

    var body: some View {
        InfoScreen(model: .init(
            image: viewModel.imageName,
            title: viewModel.title,
            message: "",
            button: .init(
                text: Strings.Localizable.biometrySetupOpenSettings,
                style: .primary,
                action: { viewModel.handle(.openSettings) })
            )
        )
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                DesignButton(
                    style: .tertiary,
                    width: .fluid,
                    imageName: DesignKit.ImageName.info,
                    action: {
                        viewModel.handle(.help)
                    })
                    .analyticsOverride(contentType: "help_icon")
            }
        })
    }
}

private class MockViewModel: BiometryUnavailableScreenViewModelProtocol {
    let imageName: ImageName = .faceid
    let title: String = "Nyissa meg a készüléke beállításait, és kapcsolja be a Face ID-t!"

    func handle(_ event: BiometryUnavailableScreenInput) {}
}

struct BiometryUnavailableScreenPreview: PreviewProvider {
    static var previews: some View {
        BiometryUnavailableScreen(viewModel: MockViewModel())
    }
}
