//
//  KycSurveyIncomeScreenViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 11..
//

import Foundation
import Combine
import Resolver
import DesignKit

class KycSurveyIncomeScreenViewModel: KycSurveyIncomeScreenViewModelProtocol {
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    private var disposeBag = Set<AnyCancellable>()

    var onProceedRequested: ((Bool, String) -> Void)?

    @Published var isIncomingSourceFilled: Bool = false

    @Published var isSalarySource: Bool = false
    @Published var isOtherSource: Bool = false
    @Published var otherSourceText: String = ""

    init() {
        populate(with: accountOpeningDraft.value)

        Publishers.CombineLatest3(
            $isSalarySource,
            $isOtherSource,
            $otherSourceText
        )
        .handleEvents(receiveOutput: { [weak self] in
            let isOtherSourceChecked = $0.1
            if !isOtherSourceChecked {
                self?.otherSourceText = ""
            }
        })
        .map {
            !(!$0.0 && $0.2.isEmpty)
        }
        .assign(to: \.isIncomingSourceFilled, onWeak: self)
        .store(in: &disposeBag)
    }

    private func populate(with accountOpeningDraft: AccountOpeningDraft) {
        guard let kycSurveyDraft = accountOpeningDraft.kycSurvey else { return }
        isSalarySource = kycSurveyDraft.incomingSources?.salary == true
        isOtherSource = kycSurveyDraft.incomingSources?.other != nil
        otherSourceText = kycSurveyDraft.incomingSources?.other ?? ""
    }

    func handle(event: KycSurveyIncomeScreenInput) {
        self.onProceedRequested?(isSalarySource, otherSourceText)
    }
}
