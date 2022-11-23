//
//  PersonalDataDocumentsScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 19..
//

import Resolver
import Combine
import DesignKit

class PersonalDataDocumentsScreenViewModel: PersonalDataDocumentsScreenViewModelProtocol {
    @Injected var draft: ReadOnly<KycDraft>
    @Injected var action: FaceKomAction

    let idType: String = "Személyi igazolvány"
    @Published var idNumber = ""
    @Published var idNumberState: ValidationState = .normal
    @Published var isIdNumberEditable: Bool = true
    @Published var addressCardNumber = ""
    @Published var addressCardNumberState: ValidationState = .normal
    @Published var isAddressCardNumberEditable: Bool = true
    @Published var validity: Date?
    @Published var validityState: ValidationState = .normal
    @Published var isValidityEditable: Bool = true
    @Published var isNextButtonEnabled: Bool = false

    private var disposeBag = Set<AnyCancellable>()

    init() {
        populate(with: draft.value)

        Publishers.CombineLatest3(
            $idNumber.removeDuplicates(),
            $validity.removeDuplicates(),
            $addressCardNumber.removeDuplicates())
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [action] (idNumber, idValidity, addressCardNumber) in
                action.update(idNumber: idNumber, idValidity: idValidity, addressCardNumber: addressCardNumber)
            })
            .store(in: &disposeBag)

        draft.publisher.map(\.fields.idCardNumber)
            .removeDuplicates()
            .map { field in
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupDocumentsNumberError)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$idNumberState)

        draft.publisher.map(\.fields.addressCardNumber)
            .removeDuplicates()
            .map { field in
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupDocumentsAddressCardNumberError)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$addressCardNumberState)

        $validity
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .map { date in
                if let date = date {
                    if date < Date() {
                        return .warning(text: Strings.Localizable.accountSetupDocumentsNumberWarningExpired)
                    } else {
                        return .normal
                    }
                } else {
                    return .error(text: Strings.Localizable.accountSetupDocumentsValidityError)
                }
            }
            .assign(to: &$validityState)

        Publishers.CombineLatest3(
            $idNumberState,
            $addressCardNumberState,
            $validityState
        )
        .map { states -> Bool in states.0 == .normal && states.1 == .normal && !states.2.isError }
        .assign(to: &$isNextButtonEnabled)
    }

    private func populate(with draft: KycDraft) {
        idNumber = draft.fields.idCardNumber.value
        isIdNumberEditable = draft.fields.idCardNumber.isEditable
        validity = DateFormatter.simple.date(from: draft.fields.idDateOfExpiry.value)
        isValidityEditable = draft.fields.idDateOfExpiry.isEditable
        addressCardNumber = draft.fields.addressCardNumber.value
        isAddressCardNumberEditable = draft.fields.addressCardNumber.isEditable
    }
}

private extension ValidationState {
    var isError: Bool {
        switch self {
        case .normal, .validated, .warning, .loading:
            return false
        case .error:
            return true
        }
    }
}
