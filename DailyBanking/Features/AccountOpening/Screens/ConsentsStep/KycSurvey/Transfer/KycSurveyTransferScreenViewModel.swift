//
//  KycSurveyTransferScreenViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 11..
//

import Foundation
import Combine
import Resolver
import DesignKit

class KycSurveyTransferScreenViewModel: KycSurveyTransferScreenViewModelProtocol {
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    private var disposeBag = Set<AnyCancellable>()

    var onProceedRequested: ((Int?, Int?) -> Void)?

    let transferPickerDataSet: [KycSurveyCurrencyAmount] = [
        .init(amountFrom: 0, amountTo: 150_000, value: "0 - 150 ezer Ft"),
        .init(amountFrom: 150_000, amountTo: 300_000, value: "150 - 300 ezer Ft"),
        .init(amountFrom: 300_000, amountTo: 500_000, value: "300 - 500 ezer Ft"),
        .init(amountFrom: 500_000, amountTo: 10_000_000, value: "500 ezer - 10 millió Ft"),
        .init(amountFrom: 10_000_000, amountTo: nil, value: "Több mint 10 millió Ft")
    ]

    @Published var isTransferPlanFilled: Bool = false

    @Published var transferRadioButtonOptions = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.commonYes, true), (Strings.Localizable.commonNo, false)],
        selected: false
    )

    @Published var selectedTransferAmount: KycSurveyCurrencyAmount?

    init() {

        populate(with: accountOpeningDraft.value)

        Publishers.CombineLatest(
            $transferRadioButtonOptions,
            $selectedTransferAmount
        )
        .handleEvents(receiveOutput: { [weak self] in
            let isTransferChecked = $0.0.selected
            if !isTransferChecked {
                self?.selectedTransferAmount = nil
            }
        })
        .map {
            !($0.0.selected && ($0.1 == nil))
        }
        .assign(to: \.isTransferPlanFilled, onWeak: self)
        .store(in: &disposeBag)

    }

    private func populate(with accountOpeningDraft: AccountOpeningDraft) {
        guard let kycSurveyDraft = accountOpeningDraft.kycSurvey else { return }

        if let transferPlan = kycSurveyDraft.transferPlan {
            transferRadioButtonOptions = transferRadioButtonOptions.selecting(value: transferPlan.amountFrom != nil)
        } else {
            transferRadioButtonOptions = transferRadioButtonOptions.selecting(value: false)
        }

        selectedTransferAmount = transferPickerDataSet.filter {
            $0.amountFrom == kycSurveyDraft.transferPlan?.amountFrom &&
            $0.amountTo == kycSurveyDraft.transferPlan?.amountTo
        }.first
    }

    func handle(event: KycSurveyTransferScreenInput) {

        switch event {
        case .proceed:
            self.onProceedRequested?(self.selectedTransferAmount?.amountFrom, self.selectedTransferAmount?.amountTo)
        case .onPressedTransferAmountPickerButton(amount: let amount):
            self.selectedTransferAmount = amount
        }
    }
}
