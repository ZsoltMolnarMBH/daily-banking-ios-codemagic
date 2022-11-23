//
//  AccountOpeningConditionsScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 12. 05..
//

import Foundation
import Resolver
import Combine

protocol AccountOpeningConditionsScreenListener: AnyObject {
    func onAccountOpeningConditionsAccepted()
}

class AccountOpeningConditionsScreenViewModel: AccountOpeningConditionsScreenViewModelProtocol {
    weak var screenListener: AccountOpeningConditionsScreenListener?

    @Injected var action: ApplicationAction
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    @Published var isLoading: Bool = false

    private var disposeBag = Set<AnyCancellable>()

    func handle(_ event: AccountOpeningConditionsScreenInput) {
        switch event {
        case .nextButtonPressed:
            acceptConditions()
        }
    }

    private func acceptConditions() {
        action
            .selectProduct(with: "BASIC")
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.screenListener?.onAccountOpeningConditionsAccepted()
                case .failure:
                    // Handle error here
                    break
                }
            }
            .store(in: &disposeBag)
    }
}
