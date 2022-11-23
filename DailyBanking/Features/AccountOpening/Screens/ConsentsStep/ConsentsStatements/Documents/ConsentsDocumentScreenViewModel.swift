//
//  ConsentsDocumentScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 08..
//

import Combine
import Resolver

protocol ConsentsDocumentScreenListener: AnyObject {
    func conditionsDocumentViewerScreenRequested(title: String, url: String)
}

class ConsentsDocumentScreenViewModel: ConsentsDocumentsScreenViewModelProtocol {
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    @Published var isValidated = false
    @Published var isConditionsAccepted = false
    @Published var isTermsAccepted = false
    @Published var isPrivacyPolicyAccepted = false

    weak var screenListener: ConsentsDocumentScreenListener?

    private var disposeBag = Set<AnyCancellable>()
    var onProceedRequested: (() -> Void)?

    init() {

        Publishers.CombineLatest3(
            $isConditionsAccepted,
            $isTermsAccepted,
            $isPrivacyPolicyAccepted
        )
        .map { $0 && $1 && $2 }
        .assign(to: \.isValidated, onWeak: self)
        .store(in: &disposeBag)

        isConditionsAccepted = accountOpeningDraft.value.statements?.acceptConditions == true
        isTermsAccepted = accountOpeningDraft.value.statements?.acceptTerms == true
        isPrivacyPolicyAccepted = accountOpeningDraft.value.statements?.acceptPrivacyPolicy == true
    }

    func handle(event: ConsentsDocumentScreenInput) {
        switch event {
        case .proceed:
            onProceedRequested?()
        case .openConditions:
            screenListener?.conditionsDocumentViewerScreenRequested(
                title: Strings.Localizable.consentsConditionsConditionsDocumentTitle,
                url: "https://ms-onboarding-test.dev.sandbox-mbh.net/static/kondicios_lista_FF_0527.pdf"
            )
        case .openPrivacyPolicy:
            screenListener?.conditionsDocumentViewerScreenRequested(
                title: Strings.Localizable.consentsConditionsPrivacyPolicyDocumentTitle,
                url: "https://ms-onboarding-test.dev.sandbox-mbh.net/static/data_protection_management_FF_0527.pdf"
            )
        case .openTerms:
            screenListener?.conditionsDocumentViewerScreenRequested(
                title: Strings.Localizable.consentsConditionsTermsDocumentTitle,
                url: "https://ms-onboarding-test.dev.sandbox-mbh.net/static/Altalanos_USZ_v6_FF_0527.pdf"
            )
        }
    }
}
