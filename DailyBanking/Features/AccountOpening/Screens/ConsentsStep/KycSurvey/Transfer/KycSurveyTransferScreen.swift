//
//  KycSurveyTransferScreen.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 11..
//

import SwiftUI
import DesignKit

protocol KycSurveyTransferScreenViewModelProtocol: ObservableObject {
    var isTransferPlanFilled: Bool { get }

    var transferRadioButtonOptions: RadioButtonOptionSet<Bool> { get set }
    var selectedTransferAmount: KycSurveyCurrencyAmount? { get }
    var transferPickerDataSet: [KycSurveyCurrencyAmount] { get }

    func handle(event: KycSurveyTransferScreenInput)
}

enum KycSurveyTransferScreenInput {
    case proceed
    case onPressedTransferAmountPickerButton(amount: KycSurveyCurrencyAmount)
}

struct KycSurveyTransferScreen<ViewModel: KycSurveyTransferScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            ScrollView {
                Card {
                    VStack(alignment: .leading, spacing: .xl) {
                        Text(Strings.Localizable.consentsKycSurveyTransferPlanTitle)
                            .textStyle(.headings5)
                            .foregroundColor(.text.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        RadioButtonGroup(
                            options: $viewModel.transferRadioButtonOptions,
                            axis: .horizontal,
                            state: .normal)
                        if viewModel.transferRadioButtonOptions.selected {
                            VStack {
                                DropDownListButton(
                                    title: Strings.Localizable.consentsKycSurveyTransferPlanAmountTitle,
                                    text: viewModel.selectedTransferAmount?.value ?? Strings.Localizable.commonPleaseSelect
                                ) {
                                    presentTransferPickerView()
                                }
                                .padding()
                            }
                            .background(Color.background.secondary)
                            .cornerRadius(.l)
                        }
                    }
                }
                .padding(.horizontal)
                .animation(.default, value: viewModel.transferRadioButtonOptions.selected)
            }
        } floater: {
            DesignButton(style: .primary, size: .large, title: Strings.Localizable.commonAllRight) {
                viewModel.handle(event: .proceed)
            }
            .disabled(!viewModel.isTransferPlanFilled)
        }
    }

    private func presentTransferPickerView() {
        let name = "transferAmountPickerView"
        Modals.alert.show(
            view: AlertRadioButtonList(
                title: Strings.Localizable.consentsKycSurveyTransferPlanAmountTitle,
                radioButtonOptions: .init(
                    dataSet: viewModel.transferPickerDataSet.map { ($0.value, $0) },
                    selected: viewModel.selectedTransferAmount ?? viewModel.transferPickerDataSet.first!
                ),
                actions: [
                    .init(title: Strings.Localizable.commonCancel, kind: .secondary, handler: { _ in
                        Modals.alert.dismiss(name)
                    }),
                    .init(title: Strings.Localizable.commonAllRight, kind: .primary, handler: { value in
                        viewModel.handle(event: .onPressedTransferAmountPickerButton(amount: value))
                        Modals.alert.dismiss(name)
                    })
                ]),
            name: name)
    }
}

private class MockViewModel: KycSurveyTransferScreenViewModelProtocol {
    var isTransferPlanFilled: Bool = true

    var transferRadioButtonOptions = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.commonYes, true), (Strings.Localizable.commonNo, false)],
        selected: true
    )

    var selectedTransferAmount: KycSurveyCurrencyAmount?

    let transferPickerDataSet: [KycSurveyCurrencyAmount] = [
        .init(amountFrom: 0, amountTo: 150_000, value: "0 - 150 ezer Ft"),
        .init(amountFrom: 150_000, amountTo: 300_000, value: "150 - 300 ezer Ft"),
        .init(amountFrom: 300_000, amountTo: 500_000, value: "300 - 500 ezer Ft"),
        .init(amountFrom: 500_000, amountTo: 10_000_000, value: "500 ezer - 10 millió Ft"),
        .init(amountFrom: 10_000_000, amountTo: nil, value: "Több mint 10 millió Ft")
    ]

    func handle(event: KycSurveyTransferScreenInput) { }
}

struct KycSurveyTransferScreen_Previews: PreviewProvider {
    static var previews: some View {
        KycSurveyTransferScreen(viewModel: MockViewModel())
    }
}
