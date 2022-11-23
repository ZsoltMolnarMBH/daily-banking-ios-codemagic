//
//  KycStartScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 22..
//

import UIKit
import SwiftUI
import DesignKit

protocol KycStartScreenViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }

    var idCardState: CardButton.ImageBadge? { get }
    var addressCardState: CardButton.ImageBadge? { get }
    var selfiState: CardButton.ImageBadge? { get }

    var isIdOptionEnabled: Bool { get }
    var isAddressCardOptionEnabled: Bool { get }
    var isSelfiOptionEnabled: Bool { get }

    var fullScreenResult: ResultModel? { get }

    func handle(_ event: KycStartScreenInput)
}

enum KycStartScreenInput {
    case help
    case onAppear
    case next
}

struct KycStartScreen<ViewModel: KycStartScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                Spacer()
                VStack(spacing: .l) {
                    Image(ImageName.cameraDuotone)
                        .resizable()
                        .frame(width: 72, height: 72)

                    Text(Strings.Localizable.kycStartPageTitle)
                        .textStyle(.headings3.thin)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text.secondary)

                    InfoParagraph(
                        title: Strings.Localizable.kycSelfieScreenTitle,
                        description: Strings.Localizable.kycStartPageSelfieDescription
                    )

                    InfoParagraph(
                        title: Strings.Localizable.kycStartPageCardTitle,
                        description: Strings.Localizable.kycStartPageCardDescription
                    )
                }
                .padding(.xl)

                Spacer()
            }
            .padding(.top, .m)
        } floater: {
            DesignButton(
                title: Strings.Localizable.commonNext,
                action: { viewModel.handle(.next) }
            )
            .disabled(viewModel.isLoading)
        }
        .navigationBarItems(trailing:
            DesignButton(
                style: .tertiary,
                width: .fluid,
                imageName: DesignKit.ImageName.help,
                action: {
                    viewModel.handle(.help)
                })
                .analyticsOverride(contentType: "help icon")
        )
        .onAppear {
            viewModel.handle(.onAppear)
        }
        .animation(.default, value: viewModel.isLoading)
        .fullscreenResult(model: viewModel.fullScreenResult)
    }
}

private struct InfoParagraph: View {
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: .xxs) {
            Text(title)
                .textStyle(.headings5)
                .multilineTextAlignment(.center)
                .foregroundColor(.text.secondary)
            Text(description)
                .textStyle(.body1)
                .multilineTextAlignment(.center)
                .foregroundColor(.text.secondary)
        }
    }
}

private class MockViewModel: KycStartScreenViewModelProtocol {
    var isLoading: Bool = false
    var isNextButtonEnabled: Bool = true

    var idCardState: CardButton.ImageBadge? = .checked
    var addressCardState: CardButton.ImageBadge?
    var selfiState: CardButton.ImageBadge?

    var isIdOptionEnabled: Bool = false
    var isAddressCardOptionEnabled: Bool = true
    var isSelfiOptionEnabled: Bool = false

    var fullScreenResult: ResultModel?

    func handle(_ event: KycStartScreenInput) {}
}

struct KycStartScreenPreviews: PreviewProvider {
    static var previews: some View {
        KycStartScreen(viewModel: MockViewModel())
    }
}
