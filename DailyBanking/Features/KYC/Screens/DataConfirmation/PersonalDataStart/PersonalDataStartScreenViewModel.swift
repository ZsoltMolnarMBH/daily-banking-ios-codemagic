//
//  AccountSetupViewModel.swift
//  app-daily-banking-ios
//
//  Created by Alexa Mark on 2021. 11. 15..
//

import Combine
import Foundation
import Resolver
import DesignKit

enum PersonalDataStartScreenEvents {
    case contactsRequested
    case personalDataRequested
    case addressRequested
    case documentsRequested
    case contactsInfoRequested
    case dataValidated
}

class PersonalDataStartScreenViewModel: ScreenViewModel<PersonalDataStartScreenEvents>, PersonalDataStartScreenViewModelProtocol {

    @Injected var action: FaceKomAction
    @Injected var draft: ReadOnly<KycDraft>

    @Published var isNextDisabled: Bool = true
    @Published var isLoading: Bool = false
    @Published var contactsCardState: CardButton.ImageBadge?
    @Published var personalDataCardState: CardButton.ImageBadge?
    @Published var addressCardState: CardButton.ImageBadge?
    @Published var documentsCardState: CardButton.ImageBadge?
    @Published var errorResult: ResultModel?

    @Published private var contactsHasOpened: Bool = false
    @Published private var personalDataHasOpened: Bool = false
    @Published private var addressHasOpened: Bool = false
    @Published private var documentsHasOpened: Bool = false
    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        let isAllScreenOpened = Publishers.CombineLatest4(
            $contactsHasOpened,
            $personalDataHasOpened,
            $addressHasOpened,
            $documentsHasOpened
        ).map { $0 && $1 && $2 && $3 }

        Publishers.CombineLatest(
            draft.publisher.map(\.fields),
            isAllScreenOpened
        ).map { fields, isAllScreenOpened in
            guard let birthDate = DateFormatter.simple.date(from: fields.dateOfBirth.value),
                    !birthDate.isUnderEighteen else { return false }
            let validatableFields = fields.addressFields + fields.personalDataFields + fields.documentFields
            return validatableFields.allSatisfy { $0.validationState == .valid } && isAllScreenOpened
        }
        .map { !$0 }
        .assign(to: &$isNextDisabled)
    }

    func handle(event: PersonalDataStartScreenInput) {
        switch event {
        case .onAppear:
            onAppear()
        case .contacts:
            contactsHasOpened = true
            events.send(.contactsRequested)
        case .personalData:
            personalDataHasOpened = true
            events.send(.personalDataRequested)
        case .address:
            addressHasOpened = true
            events.send(.addressRequested)
        case .documents:
            documentsHasOpened = true
            events.send(.documentsRequested)
        case .info:
            events.send(.contactsInfoRequested)
        case .next:
            nextButtonPressed()
        }
    }

    private func onAppear() {
        contactsCardState = makeContactsBadge()
        personalDataCardState = makePersonalDataBadge()
        addressCardState = makeAddressBadge()
        documentsCardState = makeDocumentsBadge()
    }

    private func makeContactsBadge() -> CardButton.ImageBadge? {
        guard contactsHasOpened else { return nil }
        return .checked
    }

    private func makePersonalDataBadge() -> CardButton.ImageBadge? {
        let fields = draft.value.fields
        guard personalDataHasOpened else { return nil }
        guard let birthDate = DateFormatter.simple.date(from: fields.dateOfBirth.value),
              !birthDate.isUnderEighteen  else { return .error }
        return makeBadge(from: fields.personalDataFields)
    }

    private func makeAddressBadge() -> CardButton.ImageBadge? {
        let fields = draft.value.fields
        guard addressHasOpened else { return nil }
        return makeBadge(from: fields.addressFields)
    }

    private func makeDocumentsBadge() -> CardButton.ImageBadge? {
        let fields = draft.value.fields
        guard documentsHasOpened else { return nil }
        return makeBadge(from: [fields.idCardNumber, fields.idDateOfExpiry, fields.addressCardNumber])
    }

    private func makeBadge(from fields: [FaceKom.DataField]) -> CardButton.ImageBadge {
        let isValid = fields.allSatisfy { $0.validationState == .valid }
        return isValid ? .checked : .error
    }

    private func nextButtonPressed() {
        guard !isNextDisabled else { return }
        isLoading = true
        action.stop().fireAndForget()
        action
            .reportKycFinished()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.events.send(.dataValidated)
                case .failure:
                    self?.errorResult = .genericError(screenName: "", action: {
                        self?.nextButtonPressed()
                    })
                }
            })
            .store(in: &disposeBag)
    }
}
