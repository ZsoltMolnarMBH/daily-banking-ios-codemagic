//
//  PersonalDataPersonalDataScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 17..
//

import Resolver
import Combine
import DesignKit
import CoreImage

class PersonalDataPersonalDataScreenViewModel: PersonalDataPersonalDataScreenViewModelProtocol {
    @Injected var draft: ReadOnly<KycDraft>
    @Injected var action: FaceKomAction

    private var disposeBag = Set<AnyCancellable>()

    @Published var firstName = ""
    @Published var firstNameState: ValidationState = .normal
    @Published var isFirstNameEditable = true
    @Published var lastName = ""
    @Published var lastNameState: ValidationState = .normal
    @Published var isLastNameEditable = true
    @Published var birthName = ""
    @Published var birthNameState: ValidationState = .normal
    @Published var isBirthNameEditable = true
    @Published var placeOfBirth = ""
    @Published var placeOfBirthState: ValidationState = .normal
    @Published var isPlaceOfBirthEditable = true
    @Published var mothersName = ""
    @Published var mothersNameState: ValidationState = .normal
    @Published var isMothersNameEditable = true
    @Published var nationality: String = "Magyar"
    @Published var dateOfBirth: Date?
    @Published var dateOfBirthFieldState: ValidationState = .normal
    @Published var isDateOfBirthEditable = true
    @Published var radioButtonGroup = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.commonYes, true), (Strings.Localizable.commonNo, false)],
        selected: true
    )
    @Published var isRadioButtonGroupEnabled: Bool = true
    @Published var isNextButtonEnabled: Bool = false

    init() {
        populate(with: draft.value.fields)

        draft.publisher.map(\.fields)
            .map { fields in
                guard let birthDate = DateFormatter.simple.date(from: fields.dateOfBirth.value),
                        !birthDate.isUnderEighteen else { return false }
                return fields.personalDataFields.allSatisfy { $0.validationState == .valid }
            }
            .assign(to: &$isNextButtonEnabled)

        draft.publisher.map(\.fields.firstName)
            .removeDuplicates()
            .map { field in
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupPersonalDataFirstNameErrorRequired)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$firstNameState)

        draft.publisher.map(\.fields.lastName)
            .removeDuplicates()
            .map { field in
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupPersonalDataLastNameErrorRequired)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$lastNameState)

        draft.publisher.map(\.fields.birthName)
            .removeDuplicates()
            .map { [weak self] field in
                guard self?.radioButtonGroup.selected == false else { return .normal }
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupPersonalDataBirthNameErrorRequired)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$birthNameState)

        draft.publisher.map(\.fields.placeOfBirth)
            .removeDuplicates()
            .map { field in
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupPersonalDataPlaceOfBirthErrorRequired)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$placeOfBirthState)

        draft.publisher.map(\.fields.motherName)
            .removeDuplicates()
            .map { field in
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupPersonalDataMothersNameErrorRequired)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$mothersNameState)

        $dateOfBirth
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .map { date in
                guard let date = date else {
                    return .error(text: Strings.Localizable.accountSetupPersonalDataDateOfBirthErrorRequired)
                }
                return date.isUnderEighteen ? .error(text: Strings.Localizable.accountSetupPersonalDataAgeLimitError) : .normal
            }
            .assign(to: &$dateOfBirthFieldState)

        $radioButtonGroup
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .filter { $0.selected }
            .sink(receiveValue: { [weak self] _ in
                self?.birthName = ""
            })
            .store(in: &disposeBag)

        Publishers.CombineLatest(
            Publishers.CombineLatest3(
                $firstName.removeDuplicates(),
                $lastName.removeDuplicates(),
                $birthName.removeDuplicates()
            ),
            Publishers.CombineLatest3(
                $placeOfBirth.removeDuplicates(),
                $dateOfBirth.removeDuplicates(),
                $mothersName.removeDuplicates()
            )
        )
        .dropFirst()
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [action, radioButtonGroup] names, birthData in
            let legalName = Name(firstName: names.0, lastName: names.1)
            let birthData = BirthData(
                place: birthData.0,
                date: birthData.1,
                motherName: birthData.2
            )
            action.update(
                legalName: legalName,
                birthName: radioButtonGroup.selected ? nil : names.2,
                birthData: birthData
            )
        })
        .store(in: &disposeBag)
    }

    private func populate(with fields: FaceKom.DataConfirmationFields) {
        if fields.birthName.isRequired {
            radioButtonGroup = radioButtonGroup.selecting(value: false)
        } else {
            radioButtonGroup = radioButtonGroup.selecting(value: fields.birthName.value.isEmpty)
        }

        firstName = fields.firstName.value
        lastName = fields.lastName.value
        birthName = fields.birthName.value
        placeOfBirth = fields.placeOfBirth.value
        dateOfBirth = DateFormatter.simple.date(from: fields.dateOfBirth.value)
        mothersName = fields.motherName.value

        isFirstNameEditable = fields.firstName.isEditable
        isLastNameEditable = fields.lastName.isEditable
        isBirthNameEditable = fields.birthName.isEditable
        isRadioButtonGroupEnabled = fields.birthName.isEditable && !fields.birthName.isRequired
        isPlaceOfBirthEditable = fields.placeOfBirth.isEditable
        isMothersNameEditable = fields.motherName.isEditable
        isDateOfBirthEditable = fields.dateOfBirth.isEditable
    }
}
