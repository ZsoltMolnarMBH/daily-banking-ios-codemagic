//
//  PersonalDataPersonalDataScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 17..
//

import DesignKit
import SwiftUI

protocol PersonalDataPersonalDataScreenViewModelProtocol: ObservableObject {
    var nationality: String { get }

    var firstName: String { get set }
    var firstNameState: ValidationState { get }
    var isFirstNameEditable: Bool { get }

    var lastName: String { get set }
    var lastNameState: ValidationState { get }
    var isLastNameEditable: Bool { get }

    var birthName: String { get set }
    var birthNameState: ValidationState { get }
    var isBirthNameEditable: Bool { get }

    var dateOfBirth: Date? { get set }
    var dateOfBirthFieldState: ValidationState { get set }
    var isDateOfBirthEditable: Bool { get }

    var mothersName: String { get set }
    var mothersNameState: ValidationState { get }
    var isMothersNameEditable: Bool { get }

    var placeOfBirth: String { get set }
    var placeOfBirthState: ValidationState { get set }
    var isPlaceOfBirthEditable: Bool { get }

    var radioButtonGroup: RadioButtonOptionSet<Bool> { get set }
    var isRadioButtonGroupEnabled: Bool { get }

    var isNextButtonEnabled: Bool { get }
}

struct PersonalDataPersonalDataScreen<ViewModel: PersonalDataPersonalDataScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss

    private var birthDateRange: ClosedRange<Date> {
        var dateComponents = DateComponents()
        dateComponents.year = 1900
        let startDate = Calendar(identifier: .gregorian).date(from: dateComponents) ?? .now
        return startDate...Date()
    }

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                Card {
                    VStack(spacing: .xxxl) {
                        DesignTextField(
                            title: Strings.Localizable.accountSetupPersonalDataLastNameTitle,
                            text: $viewModel.lastName,
                            validationState: viewModel.lastNameState
                        )
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .viewOnly(!viewModel.isLastNameEditable, tapAction: { showToast() })

                        DesignTextField(
                            title: Strings.Localizable.accountSetupPersonalDataFirstNameTitle,
                            text: $viewModel.firstName,
                            validationState: viewModel.firstNameState
                        )
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .viewOnly(!viewModel.isFirstNameEditable, tapAction: { showToast() })

                        HStack {
                            VStack(alignment: .leading) {
                                Text(Strings.Localizable.accountSetupPersonalDataBirthNameSameTitle)
                                    .foregroundColor(.text.secondary)
                                    .textStyle(.body2)
                                RadioButtonGroup<Bool>(
                                    options: $viewModel.radioButtonGroup
                                )
                                .disabled(!viewModel.isRadioButtonGroupEnabled)
                            }
                            Spacer()
                        }
                        .disabled(!viewModel.isRadioButtonGroupEnabled)

                        if !viewModel.radioButtonGroup.selected {
                            VStack(spacing: .xxxl) {
                                DesignTextField(
                                    title: Strings.Localizable.accountSetupPersonalDataBirthNameTitle,
                                    text: $viewModel.birthName,
                                    validationState: viewModel.birthNameState
                                )
                                .hideErrorBeforeEditing(true)
                                .hideErrorWhileEditing(true)
                                .viewOnly(!viewModel.isBirthNameEditable, tapAction: { showToast() })
                            }
                            .padding()
                            .background(Color.background.secondary)
                            .cornerRadius(.l)
                        }
                    }
                }
                Card {
                    VStack(spacing: .xxxl) {
                        DesignTextField(
                            title: Strings.Localizable.accountSetupPersonalDataNationalityTitle,
                            text: .constant(viewModel.nationality),
                            validationState: .normal
                        )
                        .viewOnly(true, tapAction: { showToast() })

                        DesignTextField(
                            title: Strings.Localizable.accountSetupPersonalDataPlaceOfBirthTitle,
                            text: $viewModel.placeOfBirth,
                            validationState: viewModel.placeOfBirthState
                        )
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .viewOnly(!viewModel.isPlaceOfBirthEditable, tapAction: { showToast() })

                        DesignDatePicker(
                            title: Strings.Localizable.accountSetupPersonalDataDateOfBirthTitle,
                            date: $viewModel.dateOfBirth,
                            state: viewModel.dateOfBirthFieldState
                        )
                        .defaultDate(Date(timeIntervalSinceReferenceDate: 0))
                        .range(birthDateRange)
                        .dateFormatter(.userFacing)
                        .viewOnly(!viewModel.isDateOfBirthEditable, tapAction: { showToast() })

                        DesignTextField(
                            title: Strings.Localizable.accountSetupPersonalDataMothersNameTitle,
                            text: $viewModel.mothersName,
                            validationState: viewModel.mothersNameState
                        )
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .viewOnly(!viewModel.isMothersNameEditable, tapAction: { showToast() })
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
        } floater: {
            DesignButton(
                title: Strings.Localizable.commonAllRight,
                action: {
                    dismiss()
                })
                .disabled(!viewModel.isNextButtonEnabled)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.secondary)
        .animation(.default, value: viewModel.radioButtonGroup.selected)
        .onTapGesture { hideKeyboard() }
        .analyticsScreenView("oao_data_personal_details")
    }

    private func showToast() {
        Modals.toast.show(text: Strings.Localizable.commonDataNotEditable)
    }
}

private class MockPersonalDataPersonalDataScreenViewModel: PersonalDataPersonalDataScreenViewModelProtocol {
    var isFirstNameEditable: Bool = true
    var isLastNameEditable: Bool = false
    var isBirthNameEditable: Bool = true
    var isDateOfBirthEditable: Bool = false
    var isMothersNameEditable: Bool = true
    var isPlaceOfBirthEditable: Bool = false
    var isRadioButtonGroupEnabled: Bool = false
    var isNextButtonEnabled: Bool = true

    var firstName: String = ""
    var firstNameState: ValidationState = .normal
    var lastName: String = ""
    var lastNameState: ValidationState = .normal
    var birthName: String = ""
    var birthNameState: ValidationState = .normal
    var countryOfBirth: Country = .init(code: "hu", name: "Magyarország")
    var countryOfBirthState: ValidationState = .normal
    var mothersName: String = ""
    var mothersNameState: ValidationState = .normal
    var placeOfBirth: String = ""
    var placeOfBirthState: ValidationState = .normal
    var dateOfBirth: Date? = Date()
    var dateOfBirthFieldState: ValidationState = .normal
    var nationality: String = "Magyar"

    var radioButtonGroup = RadioButtonOptionSet<Bool>(
        dataSet: [("igen", true), ("nem", false)],
        selected: false
    )
}

struct PersonalDataPersonalDataScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            PersonalDataPersonalDataScreen(viewModel: MockPersonalDataPersonalDataScreenViewModel())
        }
    }
}
