//
//  ConsentsStartPageScreenViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 12. 03..
//

import Combine
import Foundation
import Resolver
import DesignKit

protocol ConsentsStartPageScreenListener: AnyObject {
    func consentsStatementsScreenRequested()
    func kycSurveyScreenRequested()
    func onConsentsDataValidated()
    func helpRequested()
}

class ConsentsStartPageScreenViewModel: ConsentsStartPageScreenViewModelProtocol {
    weak var screenListener: ConsentsStartPageScreenListener?

    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>
    @Injected var action: ApplicationAction

    @Published var isValidateButtonEnabled: Bool = false
    @Published var statementsCardState: CardButton.ImageBadge?
    @Published var kycSurveyCardState: CardButton.ImageBadge?
    @Published var isLoading: Bool = false
    @Published var error: ResultModel?

    private var disposeBag = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest(
            $statementsCardState.map { $0 == .checked },
            $kycSurveyCardState.map { $0 == .checked }
        )
        .map { $0 && $1 }
        .assign(to: \.isValidateButtonEnabled, onWeak: self)
        .store(in: &disposeBag)
    }

    func handle(event: ConsentsStartPageScreenInput) {
        switch event {
        case .statementsSelected:
            screenListener?.consentsStatementsScreenRequested()
        case .kycSurveySelected:
            screenListener?.kycSurveyScreenRequested()
        case .navigationBarInfoButtonPressed:
            screenListener?.helpRequested()
        case .validateButtonPressed:
            validateButtonPressed()
        case .onAppear:
            setValidationStates()
        }
    }

    private func setValidationStates() {
        statementsCardState = imageBadge(from: accountOpeningDraft.value.statements?.isValid)
        kycSurveyCardState = imageBadge(from: accountOpeningDraft.value.kycSurvey?.isValid)
    }

    private func imageBadge(from boolean: Bool?) -> CardButton.ImageBadge? {
        guard let boolean = boolean else { return nil }
        return boolean ? .checked : .error
    }

    private func validateButtonPressed() {
        guard let statements = accountOpeningDraft.value.statements, let kycSurvey = accountOpeningDraft.value.kycSurvey else {
            assertionFailure("Draft's statement is empty")
            return
        }
        isLoading = true
        action
            .updateStatements(with: statements, kycSurvey: kycSurvey)
            .append(action.requestContract())
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.screenListener?.onConsentsDataValidated()
                case .failure:
                    self?.error = .genericError(screenName: "", action: {
                        self?.error = nil
                        self?.validateButtonPressed()
                    })
                }
            }
            .store(in: &disposeBag)
    }
}
