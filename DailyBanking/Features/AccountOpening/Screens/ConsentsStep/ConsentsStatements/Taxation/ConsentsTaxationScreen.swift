//
//  ConsentsTaxationScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 08..
//

import DesignKit
import SwiftUI

enum ConsentsTaxationScreenInput {
    case addEmptyTaxation
    case removeTaxation(_ taxation: Consent.Taxation)
    case taxationResidencySelected(selectedResidency: Consent.TaxResidency)
    case proceed
    case presentCountryPicker
}

protocol ConsentsTaxationViewModelProtocol: ObservableObject {
    var isValidated: Bool { get }
    var taxResidencyPickerDataSet: [(String, Consent.TaxResidency)] { get }
    var selectedTaxResidency: Consent.TaxResidency? { get }
    var selectedTaxationIndex: Int { get set }
    var taxation: [Consent.Taxation] { get set }
    var disabledCountryCodes: [String] { get }

    func handle(event: ConsentsTaxationScreenInput)
}

struct ConsentsTaxationScreen<ViewModel: ConsentsTaxationViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    private let scrollViewBottomInset: CGFloat = 80.0

    var body: some View {
        FormLayout {
            Card {
                VStack(alignment: .leading, spacing: .xl) {
                    Text(Strings.Localizable.accountOpeningTaxResidencyTypeTitle)
                        .textStyle(.headings5)
                        .foregroundColor(.text.primary)
                    Text(Strings.Localizable.accountOpeningTaxResidencyTypeDescription)
                        .textStyle(.body2)
                        .foregroundColor(.text.secondary)
                    DropDownListButton(text: viewModel.selectedTaxResidency?.label ?? Strings.Localizable.commonPleaseSelect) {
                        presentTaxationResidencyPicker()
                    }
                    if !viewModel.taxation.isEmpty {
                        taxationList
                    }
                    if let selectedTaxationResidency = viewModel.selectedTaxResidency, selectedTaxationResidency != .hungary {
                        DesignButton(
                            style: .tertiary,
                            title: Strings.Localizable.accountOpeningTaxResidencyAddCountry,
                            imageName: DesignKit.ImageName.add
                        ) {
                            viewModel.handle(event: .addEmptyTaxation)
                        }
                    }
                }
            }
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
        .animation(.fast, value: viewModel.taxation)
        .onTapGesture {
            hideKeyboard()
        }
    }

    var taxationList: some View {
        LazyVStack(spacing: .xs) {
            ForEach($viewModel.taxation, id: \.id) { taxation in
                VStack(spacing: .xxs) {
                    VStack(spacing: .xxxl) {
                        DropDownListButton(
                            title: Strings.Localizable.commonCountry,
                            text: taxation.country.name.wrappedValue.isEmpty ?
                                Strings.Localizable.commonPleaseSelect : taxation.country.name.wrappedValue
                        ) {
                            viewModel.selectedTaxationIndex = viewModel.taxation.firstIndex(of: taxation.wrappedValue) ?? 0
                            viewModel.handle(event: .presentCountryPicker)
                        }
                        DesignTextField(
                            title: Strings.Localizable.accountOpeningTaxResidencyAbroadTax,
                            text: taxation.taxNumber,
                            validationState: taxation.taxNumberValidationState.wrappedValue
                        )
                    }
                    if viewModel.taxation.first != taxation.wrappedValue {
                        DesignButton(
                            style: .destructive,
                            title: Strings.Localizable.accountOpeningTaxResidencyDeleteCountry,
                            imageName: DesignKit.ImageName.delete
                        ) {
                            viewModel.handle(event: .removeTaxation(taxation.wrappedValue))
                        }
                        .padding(.top)
                    }
                }
                .animation(.default, value: taxation.taxNumberValidationState.wrappedValue)
                .padding()
                .background(Color.background.secondary)
                .cornerRadius(.l)
            }
        }
    }

    func presentTaxationResidencyPicker() {
        let name = "taxationTypePickerView"
        Modals.alert.show(
            view: AlertRadioButtonList(
                title: Strings.Localizable.accountOpeningTaxResidencyTypeTitle,
                radioButtonOptions: RadioButtonOptionSet<Consent.TaxResidency>(
                    dataSet: viewModel.taxResidencyPickerDataSet,
                    selected: viewModel.selectedTaxResidency ?? .hungary
                ),
                actions: [
                    .init(title: Strings.Localizable.commonCancel, kind: .secondary, handler: { _ in
                        Modals.alert.dismiss(name)
                    }),
                    .init(title: Strings.Localizable.commonAllRight, kind: .primary, handler: { value in
                        viewModel.handle(event: .taxationResidencySelected(selectedResidency: value))
                        Modals.alert.dismiss(name)
                    })
                ]),
            name: name)
    }
}

private class MockViewModel: ConsentsTaxationViewModelProtocol {
    var isValidated: Bool = true
    var disabledCountryCodes: [String] = []
    var selectedTaxResidency: Consent.TaxResidency? = .hungaryAbroad
    var taxResidencyPickerDataSet: [(String, Consent.TaxResidency)] = []
    var selectedTaxationIndex: Int = 0
    var taxation: [Consent.Taxation] = [
        .init(country: .init(code: "hu", name: "Magyarország"), taxNumber: ""),
        .init(country: .init(code: "hu", name: "Magyarország"), taxNumber: "123456"),
        .init(country: .init(code: "hu", name: "Magyarország"), taxNumber: "")
    ]

    func handle(event: ConsentsTaxationScreenInput) {}
}

struct TaxationScreenPreview: PreviewProvider {
    static var previews: some View {
        ConsentsTaxationScreen(viewModel: MockViewModel())
    }
}
