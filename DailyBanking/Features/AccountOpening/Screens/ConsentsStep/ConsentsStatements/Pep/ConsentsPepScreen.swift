//
//  ConsentsPepScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 08..
//

import DesignKit
import SwiftUI

enum ConsentsPepScreenInput {
    case proceed
    case help
}

protocol ConsentsPepScreenViewModelProtocol: ObservableObject {
    var isValidated: Bool { get }
    var showPepInfoCard: Bool { get }
    var isPepRadioButtonState: ValidationState { get }
    var radioButtonOptions: RadioButtonOptionSet<Bool> { get set }

    func handle(event: ConsentsPepScreenInput)
}

struct ConsentsPepScreen<ViewModel: ConsentsPepScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                pepCard
                if viewModel.showPepInfoCard {
                    pepInfoCard
                }
            }
            .animation(.fast, value: viewModel.showPepInfoCard)
            .padding()
            Spacer()
        } floater: {
            DesignButton(
                style: .primary,
                size: .large,
                title: Strings.Localizable.commonAllRight
            ) {
                viewModel.handle(event: .proceed)
            }
            .disabled(!viewModel.isValidated)
        }
    }

    var pepCard: some View {
        Card {
            VStack(alignment: .leading, spacing: .xl) {
                Text(Strings.Localizable.consentsStatementsPepTitle)
                    .textStyle(.headings5)
                    .foregroundColor(.text.primary)
                Text(Strings.Localizable.consentsStatementsPepDescription)
                    .textStyle(.body2)
                    .foregroundColor(.text.secondary)
                RadioButtonGroup(
                    options: $viewModel.radioButtonOptions,
                    axis: .horizontal,
                    state: viewModel.isPepRadioButtonState)
            }
        }
    }

    var pepInfoCard: some View {
        Card {
            VStack(spacing: .xs) {
                Image(.warningSemantic)
                Text(Strings.Localizable.consentsStatementsPepWarningTitle)
                    .textStyle(.headings4)
                    .foregroundColor(.text.primary)
                Text(Strings.Localizable.consentsStatementsPepWarningDescription)
                    .textStyle(.body2)
                    .foregroundColor(.text.secondary)
                    .multilineTextAlignment(.center)
                DesignButton(style: .primary, size: .large, title: Strings.Localizable.commonHelpRequest) {
                    viewModel.handle(event: .help)
                }
                .padding(.top, .xxl)
            }
        }
    }
}

private class MockViewModel: ConsentsPepScreenViewModelProtocol {
    var isValidated: Bool = false
    var showPepInfoCard: Bool = false
    var isPepRadioButtonState: ValidationState = .error(
        text: "Sajnos ebben az esetben online nem nyithat bankszámlát."
    )
    var radioButtonOptions: RadioButtonOptionSet<Bool> = RadioButtonOptionSet<Bool>(
        dataSet: [("igen", true), ("nem", false)],
        selected: true
    )

    func handle(event: ConsentsPepScreenInput) {}
}

struct ConsentsPepPreviews: PreviewProvider {
    static var previews: some View {
        ConsentsPepScreen(viewModel: MockViewModel())
    }
}
