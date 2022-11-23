//
//  BiometryMultiUsageInfoScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 11..
//

import DesignKit
import SwiftUI

protocol BiometryMultiUsageInfoScreenViewModelProtocol: ObservableObject {
    var biometryImage: ImageName { get }
    var title: String { get }
    var message: String { get }
    var subtitle: String { get }
    var analyticsScreenName: String { get }

    func handle(event: BiometryMultiUsageInfoScreenInput)
}

enum BiometryMultiUsageInfoScreenInput {
    case close
}

struct BiometryMultiUsageInfoScreen<ViewModel: BiometryMultiUsageInfoScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        InfoScreen(model: .init(
            image: viewModel.biometryImage,
            title: viewModel.title,
            message: viewModel.message,
            button: .init(
                text: Strings.Localizable.commonAllRight,
                style: .primary,
                action: { viewModel.handle(event: .close) })))
        .analyticsScreenView(viewModel.analyticsScreenName)
    }
}

private class MockViewModel: BiometryMultiUsageInfoScreenViewModelProtocol {
    var analyticsScreenName: String = ""
    var biometryImage: ImageName = .touchId
    var title: String = "Mi történik, ha mások ujjlenyomata is be van állítva a készüléken?"
    var message: String = "Az azonosításhoz a készüléken beállított ujjlenyomatokat használjuk, ezért bárki beléphet az appba és jóváhagyhatja a tranzakciókat, akinek az ujjlenyomatát beállította." // swiftlint:disable:this line_length
    var subtitle: String = "Kérjük, ezt vegye figyelembe, mielőtt engedélyezi az ujjlenyomattal (Touch ID) történő azonosítást!"

    func handle(event: BiometryMultiUsageInfoScreenInput) {}
}

struct BiometryMultiUsageInfoScreenPreviews: PreviewProvider {
    static var previews: some View {
        BiometryMultiUsageInfoScreen(viewModel: MockViewModel())
    }
}
