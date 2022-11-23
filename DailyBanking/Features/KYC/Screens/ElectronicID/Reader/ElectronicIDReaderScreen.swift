//
//  ElectronicIDReaderScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 14..
//

import Combine
import DesignKit
import SwiftUI

protocol ElectronicIDReaderScreenViewModelProtocol: ObservableObject {
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }
    var errorResult: ResultModel? { get }
    var isActionsEnabled: Bool { get }
    func handle(_ event: ElectronicIDReaderScreenInputs)
}

enum ElectronicIDReaderScreenInputs {
    case eIDHelp
    case nfcPositionHelp
    case startReading
    case skip
}

struct ElectronicIDReaderScreen<ViewModel: ElectronicIDReaderScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: 0) {
                LottieView(animation: .nfc, loopMode: .loop)
                    .frame(width: 128, height: 128)
                    .padding(.bottom, .xl)
                Text(Strings.Localizable.kycEidTitle)
                    .textStyle(.headings3.thin)
                    .padding(.bottom, .xs)
                Text(Strings.Localizable.kycEidDescriptionIos)
                    .textStyle(.body1)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, .xxxl)

                DesignButton(
                    style: .tertiary,
                    title: Strings.Localizable.kycEidHelpActionTitle,
                    action: {
                        viewModel.handle(.nfcPositionHelp)
                    }
                )
            }
            .padding(.horizontal, .xxxl)
        } floater: {
            VStack(spacing: .m) {
                if viewModel.isActionsEnabled {
                    DesignButton(
                        style: .primary,
                        title: Strings.Localizable.kycEidPrimaryActionTitle,
                        action: {
                            viewModel.handle(.startReading)
                        })

                    DesignButton(
                        style: .secondary,
                        title: Strings.Localizable.commonSkip,
                        action: {
                            viewModel.handle(.skip)
                        })
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .highlight.primary.background))
                        .scaleEffect(1.3)
                }
            }
            .frame(height: 120)
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                DesignButton(
                    style: .tertiary,
                    width: .fluid,
                    imageName: DesignKit.ImageName.info,
                    action: {
                        viewModel.handle(.eIDHelp)
                    })
                    .analyticsOverride(contentType: "info icon")
            }
        })
        .designAlert(viewModel.bottomAlert)
        .fullscreenResult(model: viewModel.errorResult)
    }
}

private class MockViewModel: ElectronicIDReaderScreenViewModelProtocol {
    var errorResult: ResultModel?
    var isActionsEnabled: Bool = false
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }

    func handle(_ event: ElectronicIDReaderScreenInputs) {}
}

struct ElectronicIDPreviews: PreviewProvider {
    static var previews: some View {
        ElectronicIDReaderScreen(viewModel: MockViewModel())
            .preferredColorScheme(.light)
    }
}
