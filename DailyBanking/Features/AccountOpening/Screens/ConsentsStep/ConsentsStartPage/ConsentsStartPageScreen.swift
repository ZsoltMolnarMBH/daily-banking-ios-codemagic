//
//  ConsentsStartPageScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 12. 03..
//

import SwiftUI
import DesignKit

protocol ConsentsStartPageScreenViewModelProtocol: ObservableObject {
    var isValidateButtonEnabled: Bool { get }
    var statementsCardState: CardButton.ImageBadge? { get }
    var kycSurveyCardState: CardButton.ImageBadge? { get }
    var isLoading: Bool { get }
    var error: ResultModel? { get }

    func handle(event: ConsentsStartPageScreenInput)
}

enum ConsentsStartPageScreenInput {
    case onAppear
    case statementsSelected
    case kycSurveySelected
    case navigationBarInfoButtonPressed
    case validateButtonPressed
}

struct ConsentsStartPageScreen<ViewModel: ConsentsStartPageScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                VStack(alignment: .leading, spacing: .xs) {
                    Text(Strings.Localizable.consentsStartPageInfoTitle)
                        .textStyle(.headings5)
                        .foregroundColor(.text.tertiary)
                    Text(Strings.Localizable.consentsStartPageInfoDescription)
                        .textStyle(.body2)
                        .foregroundColor(.text.secondary)
                }
                VStack(spacing: .m) {
                    CardButton(
                        title: Strings.Localizable.consentsStartPageStatements,
                        image: Image(.phone),
                        imageBadge: viewModel.statementsCardState
                    ) {
                        viewModel.handle(event: .statementsSelected)
                    }
                    CardButton(
                        title: Strings.Localizable.consentsStartPageKycSurvey,
                        image: Image(.user),
                        imageBadge: viewModel.kycSurveyCardState
                    ) {
                        viewModel.handle(event: .kycSurveySelected)
                    }
                }
                Spacer()
            }
            .padding(.m)
            .padding(.top, .xxxl)
        } floater: {
            DesignButton(style: .primary, size: .large, title: Strings.Localizable.consentsStartPageOpenContract) {
                viewModel.handle(event: .validateButtonPressed)
            }
            .disabled(!viewModel.isValidateButtonEnabled)
        }
        .navigationBarItems(trailing:
            Button(
                action: {
                    analytics.logButtonPress(contentType: "help icon", componentLabel: nil)
                    viewModel.handle(event: .navigationBarInfoButtonPressed)
                },
                label: {
                    Image(.help)
                        .foregroundColor(.highlight.tertiary)
                }
            )
        )
        .background(Color.background.secondary)
        .onAppear {
            viewModel.handle(event: .onAppear)
        }
        .fullscreenResult(model: viewModel.error)
        .fullScreenProgress(by: viewModel.isLoading, name: "consentstart")
        .analyticsScreenView("oao_progress_kyc")
    }
}

struct ConsentsStartPageScreen_Previews: PreviewProvider {
    static var previews: some View {
        ConsentsStartPageScreen(viewModel: MockConsentsStartPageScreenViewModel())
    }
}

private class MockConsentsStartPageScreenViewModel: ConsentsStartPageScreenViewModelProtocol {
    var error: ResultModel?
    var statementsCardState: CardButton.ImageBadge? = .checked
    var kycSurveyCardState: CardButton.ImageBadge? = .checked
    var isLoading: Bool = false
    var isValidateButtonEnabled: Bool = false

    func handle(event: ConsentsStartPageScreenInput) {}
}
