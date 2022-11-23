//
//  ContactsScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 16..
//

import Foundation
import Resolver
import Combine
import DesignKit

class PersonalDataContactsScreenViewModel: PersonalDataContactsScreenViewModelProtocol {
    @Injected var draft: ReadOnly<KycDraft>

    @Published var email: String = ""
    @Published var phoneNumber: String = ""

    init() {
        email = draft.value.fields.email.value
        phoneNumber = draft.value.fields.phoneNumber.value
    }
}
