//
//  PersonalDataAddressScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 19..
//

import Resolver
import Combine
import DesignKit

class PersonalDataAddressScreenViewModel: PersonalDataAddressScreenViewModelProtocol {
    @Injected var draft: ReadOnly<KycDraft>
    @Injected var action: FaceKomAction

    private var disposeBag = Set<AnyCancellable>()

    @Published var country: String = "Magyarország"
    @Published var address: String = ""
    @Published var addressState: ValidationState = .normal
    @Published var isNextButtonEnabled: Bool = false

    init() {
        address = draft.value.fields.address.value

        draft.publisher.map(\.fields.address)
            .removeDuplicates()
            .map { field in
                switch field.validationState {
                case .valid:
                    return .normal
                case .invalidEmpty:
                    return .error(text: Strings.Localizable.accountSetupAddressAddressError)
                case .invalidFomat:
                    return .error(text: Strings.Localizable.commonErrorWrongFormat)
                }
            }
            .assign(to: &$addressState)

        $addressState
            .map { $0 == .normal }
            .assign(to: &$isNextButtonEnabled)

        $address
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [action] address in
                action.update(legalAddress: address)
            })
            .store(in: &disposeBag)
    }
}
