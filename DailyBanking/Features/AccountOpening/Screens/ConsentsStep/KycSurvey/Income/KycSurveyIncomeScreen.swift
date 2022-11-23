//
//  KycSurveyIncomeScreen.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 11..
//

import DesignKit
import SwiftUI

protocol KycSurveyIncomeScreenViewModelProtocol: ObservableObject {
    var isIncomingSourceFilled: Bool { get }

    var isSalarySource: Bool { get set }
    var isOtherSource: Bool { get set }
    var otherSourceText: String { get set }

    func handle(event: KycSurveyIncomeScreenInput)
}

enum KycSurveyIncomeScreenInput {
    case proceed
}

struct KycSurveyIncomeScreen<ViewModel: KycSurveyIncomeScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            ScrollView {
                Card {
                    VStack(alignment: .leading, spacing: .xl) {
                        Text(Strings.Localizable.consentsKycSurveyIncomingSourceTitle)
                            .textStyle(.headings5)
                            .foregroundColor(.text.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        CheckBoxRow(
                            isChecked: $viewModel.isSalarySource,
                            text: Strings.Localizable.consentsKycSurveyIncomingSourceSalary
                        ) { viewModel.isSalarySource = !viewModel.isSalarySource }
                        CheckBoxRow(
                            isChecked: $viewModel.isOtherSource,
                            text: Strings.Localizable.consentsKycSurveyIncomingSourceOther
                        ) { viewModel.isOtherSource = !viewModel.isOtherSource }
                        if viewModel.isOtherSource {
                            VStack {
                                DesignTextField(
                                    title: Strings.Localizable.consentsKycSurveyIncomingSourceOtherTitle,
                                    text: $viewModel.otherSourceText,
                                    validationState: .normal
                                )
                                .padding()
                            }
                            .background(Color.background.secondary)
                            .cornerRadius(.l)
                        }
                    }
                }
                .padding(.horizontal)
                .animation(.default, value: viewModel.isOtherSource)
            }
        } floater: {
            DesignButton(style: .primary, size: .large, title: Strings.Localizable.commonAllRight) {
                viewModel.handle(event: .proceed)
            }
            .disabled(!viewModel.isIncomingSourceFilled)
        }
    }
}

private class MockViewModel: KycSurveyIncomeScreenViewModelProtocol {
    var isIncomingSourceFilled: Bool = true

    var isSalarySource: Bool = true

    var isOtherSource: Bool = false

    var otherSourceText: String = ""

    func handle(event: KycSurveyIncomeScreenInput) { }
}

struct KycSurveyIncomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        KycSurveyIncomeScreen(viewModel: MockViewModel())
    }
}
