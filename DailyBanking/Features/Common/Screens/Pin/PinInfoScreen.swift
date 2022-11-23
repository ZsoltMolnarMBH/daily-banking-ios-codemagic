//
//  PinCreationInfoScreen.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 11. 09..
//

import SwiftUI
import DesignKit

enum PinInfoScreenInput {
    case hint
    case proceed
}

protocol PinInfoScreenViewModelProtocol: ObservableObject {
    func handle(input: PinInfoScreenInput)
}

struct PinInfoScreen<ViewModel: PinInfoScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        InfoScreen(model: .init(
            image: .passwordLockDuotone,
            title: Strings.Localizable.pinInfoTitle,
            message: Strings.Localizable.pinInfoSubtitle,
            messageButton: .init(
                text: Strings.Localizable.pinInfoHint,
                style: .tertiary,
                action: { viewModel.handle(input: .hint) }),
            button: .init(
                text: Strings.Localizable.pinInfoCreate,
                style: .primary,
                action: { viewModel.handle(input: .proceed) }))
        )
        .background(Color.background.secondary)
    }
}

struct PinCreationInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        PinInfoScreen<MockPinInfoScreenViewModel>(viewModel: MockPinInfoScreenViewModel())
    }
}

class MockPinInfoScreenViewModel: PinInfoScreenViewModelProtocol {
    func handle(input: PinInfoScreenInput) { }
}
