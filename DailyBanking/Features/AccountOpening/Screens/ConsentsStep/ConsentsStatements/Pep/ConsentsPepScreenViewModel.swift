//
//  ConsentsPepScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 08..
//

import Combine
import Foundation
import DesignKit
import Resolver

protocol ConsentsPepScreenListener: AnyObject {
    func helpRequested()
}

class ConsentsPepScreenViewModel: ConsentsPepScreenViewModelProtocol {
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    weak var screenListener: ConsentsPepScreenListener?

    @Published var isValidated: Bool = false
    @Published var showPepInfoCard: Bool = false
    @Published var isPepRadioButtonState: ValidationState = .normal
    @Published var radioButtonOptions = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.commonYes, true), (Strings.Localizable.commonNo, false)],
        selected: false
    )
    private var disposeBag = Set<AnyCancellable>()
    var onProceedRequested: (() -> Void)?

    init() {
        accountOpeningDraft
            .publisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] draft in
                self?.populate(with: draft)
            }
            .store(in: &disposeBag)

        $radioButtonOptions
            .sink(receiveValue: { [weak self] value in
                self?.isPepRadioButtonState = value.selected ?
                    .error(text: Strings.Localizable.consentsStatementsPepError) : .normal
                self?.showPepInfoCard = value.selected
                self?.isValidated = !value.selected
            })
            .store(in: &disposeBag)

        populate(with: accountOpeningDraft.value)
    }

    func handle(event: ConsentsPepScreenInput) {
        switch event {
        case .proceed:
            onProceedRequested?()
        case .help:
            screenListener?.helpRequested()
        }
    }

    private func populate(with accountOpeningDraft: AccountOpeningDraft) {
        guard let statementsDraft = accountOpeningDraft.statements else { return }
        radioButtonOptions = radioButtonOptions.selecting(value: statementsDraft.isPep)
    }
}
