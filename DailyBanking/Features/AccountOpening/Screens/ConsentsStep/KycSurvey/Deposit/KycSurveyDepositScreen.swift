//
//  KycSurveyDepositScreen.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 11..
//

import SwiftUI
import DesignKit

protocol KycSurveyDepositScreenViewModelProtocol: ObservableObject {
    var isDepositPlanFilled: Bool { get }

    var depositRadioButtonOptions: RadioButtonOptionSet<Bool> { get set }
    var selectedDepositAmount: KycSurveyCurrencyAmount? { get }
    var depositPickerDataSet: [KycSurveyCurrencyAmount] { get }

    func handle(event: KycSurveyDepositScreenInput)
}

enum KycSurveyDepositScreenInput {
    case proceed
    case onPressedDepositAmountPickerButton(amount: KycSurveyCurrencyAmount)
}

struct KycSurveyDepositScreen<ViewModel: KycSurveyDepositScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            ScrollView {
                Card {
                    VStack(alignment: .leading, spacing: .xl) {
                        Text(Strings.Localizable.consentsKycSurveyDepositPlanTitle)
                            .textStyle(.headings5)
                            .foregroundColor(.text.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        RadioButtonGroup(
                            options: $viewModel.depositRadioButtonOptions,
                            axis: .horizontal,
                            state: .normal)
                        if viewModel.depositRadioButtonOptions.selected {
                            VStack {
                                DropDownListButton(
                                    title: Strings.Localizable.consentsKycSurveyDepositPlanAmountTitle,
                                    text: viewModel.selectedDepositAmount?.value ?? Strings.Localizable.commonPleaseSelect
                                ) {
                                    presentDepositPickerView()
                                }
                                .padding()
                            }
                            .background(Color.background.secondary)
                            .cornerRadius(.l)
                        }
                    }
                }
                .padding(.horizontal)
                .animation(.default, value: viewModel.depositRadioButtonOptions.selected)
            }
        } floater: {
            DesignButton(style: .primary, size: .large, title: Strings.Localizable.commonAllRight) {
                viewModel.handle(event: .proceed)
            }
            .disabled(!viewModel.isDepositPlanFilled)
        }
    }

    private func presentDepositPickerView() {
        let name = "cashAmountPickerView"
        Modals.alert.show(
            view: AlertRadioButtonList(
                title: Strings.Localizable.consentsKycSurveyDepositPlanAmountTitle,
                radioButtonOptions: .init(
                    dataSet: viewModel.depositPickerDataSet.map { ($0.value, $0) },
                    selected: viewModel.selectedDepositAmount ?? viewModel.depositPickerDataSet.first!
                ),
                actions: [
                    .init(title: Strings.Localizable.commonCancel, kind: .secondary, handler: { _ in
                        Modals.alert.dismiss(name)
                    }),
                    .init(title: Strings.Localizable.commonAllRight, kind: .primary, handler: { value in
                        viewModel.handle(event: .onPressedDepositAmountPickerButton(amount: value))
                        Modals.alert.dismiss(name)
                    })
                ]),
            name: name
        )
    }
}

private class MockViewModel: KycSurveyDepositScreenViewModelProtocol {

    var isDepositPlanFilled: Bool = true

    var depositRadioButtonOptions = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.commonYes, true), (Strings.Localizable.commonNo, false)],
        selected: false
    )

    var selectedDepositAmount: KycSurveyCurrencyAmount?

    let depositPickerDataSet: [KycSurveyCurrencyAmount] = [
        .init(amountFrom: 0, amountTo: 50_000, value: "0 - 50 ezer Ft"),
        .init(amountFrom: 50_000, amountTo: 500_000, value: "50 - 500 ezer Ft"),
        .init(amountFrom: 500_000, amountTo: 3_000_000, value: "500 ezer - 3 millió Ft"),
        .init(amountFrom: 3_000_000, amountTo: nil, value: "Több mint 3 millió Ft")
    ]

    func handle(event: KycSurveyDepositScreenInput) { }
}

struct KycSurveyDepositScreen_Previews: PreviewProvider {
    static var previews: some View {
        KycSurveyDepositScreen(viewModel: MockViewModel())
    }
}
