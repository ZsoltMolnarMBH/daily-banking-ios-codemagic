//
//  KycSurveyDepositScreenViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 11..
//

import Foundation
import Combine
import Resolver
import DesignKit

class KycSurveyDepositScreenViewModel: KycSurveyDepositScreenViewModelProtocol {
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    private var disposeBag = Set<AnyCancellable>()

    var onProceedRequested: ((Int?, Int?) -> Void)?

    let depositPickerDataSet: [KycSurveyCurrencyAmount] = [
        .init(amountFrom: 0, amountTo: 50_000, value: "0 - 50 ezer Ft"),
        .init(amountFrom: 50_000, amountTo: 500_000, value: "50 - 500 ezer Ft"),
        .init(amountFrom: 500_000, amountTo: 3_000_000, value: "500 ezer - 3 millió Ft"),
        .init(amountFrom: 3_000_000, amountTo: nil, value: "Több mint 3 millió Ft")
    ]

    @Published var isDepositPlanFilled: Bool = false

    @Published var depositRadioButtonOptions = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.commonYes, true), (Strings.Localizable.commonNo, false)],
        selected: false
    )
    @Published var selectedDepositAmount: KycSurveyCurrencyAmount?

    init() {

        populate(with: accountOpeningDraft.value)

        Publishers.CombineLatest(
            $depositRadioButtonOptions,
            $selectedDepositAmount
        )
        .handleEvents(receiveOutput: { [weak self] in
            let isDepositChecked = $0.0.selected
            if !isDepositChecked {
                self?.selectedDepositAmount = nil
            }
        })
        .map {
            !($0.0.selected && ($0.1 == nil))
        }
        .assign(to: \.isDepositPlanFilled, onWeak: self)
        .store(in: &disposeBag)

    }

    private func populate(with accountOpeningDraft: AccountOpeningDraft) {
        guard let kycSurveyDraft = accountOpeningDraft.kycSurvey else { return }

        if let depositPlan = kycSurveyDraft.depositPlan {
            depositRadioButtonOptions = depositRadioButtonOptions.selecting(value: depositPlan.amountFrom != nil)
        } else {
            depositRadioButtonOptions = depositRadioButtonOptions.selecting(value: false)
        }
        selectedDepositAmount = depositPickerDataSet.filter {
            $0.amountFrom == kycSurveyDraft.depositPlan?.amountFrom &&
            $0.amountTo == kycSurveyDraft.depositPlan?.amountTo
        }.first

    }

    func handle(event: KycSurveyDepositScreenInput) {

        switch event {
        case .proceed:
            self.onProceedRequested?(self.selectedDepositAmount?.amountFrom, self.selectedDepositAmount?.amountTo)
        case .onPressedDepositAmountPickerButton(let amount):
            self.selectedDepositAmount = amount
        }
    }
}
