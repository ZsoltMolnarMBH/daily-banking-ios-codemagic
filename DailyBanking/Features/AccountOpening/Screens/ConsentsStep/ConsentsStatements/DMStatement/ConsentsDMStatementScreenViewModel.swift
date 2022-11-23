//
//  ConsentsDMStatementScreenViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 09..
//

import Foundation
import Combine
import Resolver
import DesignKit

protocol ConsentsDMStatementScreenListener: AnyObject {
    func helpRequested()
}

class ConsentsDMStatementScreenViewModel: ConsentsDMStatementScreenViewModelProtocol {
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    @Published var isValidated = false
    @Published var isPushSelected = false
    @Published var isEmailSelected = false
    @Published var robinsonSelected: Bool?

    weak var screenListener: ConsentsDMStatementScreenListener?
    private var disposeBag = Set<AnyCancellable>()
    var onProceedRequested: ((AccountOpeningDraft.Statements.DMStatement?) -> Void)?

    @Published var enableDMRBSingleOption: RadioButtonOptionSet<Bool> = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.dmStatementsNotificationOn, true)],
        selected: false
    )

    @Published var disableDMRBSingleOption: RadioButtonOptionSet<Bool> = RadioButtonOptionSet<Bool>(
        dataSet: [
            .init(
                title: Strings.Localizable.dmStatementsNotificationOff,
                subtitle: Strings.Localizable.dmStatementsNotificationOffHint,
                value: true
            )
        ],
        selected: false
    )

    init() {
        Publishers.CombineLatest3($isPushSelected, $isEmailSelected, $robinsonSelected)
            .receive(on: DispatchQueue.main)
            .map { $0 || $1 || $2 ?? false}
            .assign(to: &$isValidated)

        $enableDMRBSingleOption
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.selected }
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if !self.isPushSelected && !self.isEmailSelected {
                    self.isPushSelected = true
                    self.isEmailSelected = true
                }
                self.robinsonSelected = false
                self.disableDMRBSingleOption = self.disableDMRBSingleOption.selecting(value: false)
            })
            .store(in: &disposeBag)

        $disableDMRBSingleOption
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.selected }
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.isPushSelected = false
                self.isEmailSelected = false
                self.robinsonSelected = true
                self.enableDMRBSingleOption = self.enableDMRBSingleOption.selecting(value: false)
            })
            .store(in: &disposeBag)

        $isPushSelected.merge(with: $isEmailSelected)
            .receive(on: DispatchQueue.main)
            .filter { $0 == true }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.robinsonSelected = false
                self.disableDMRBSingleOption = self.disableDMRBSingleOption.selecting(value: false)
                self.enableDMRBSingleOption = self.enableDMRBSingleOption.selecting(value: true)
            }
            .store(in: &disposeBag)

        isPushSelected = accountOpeningDraft.value.statements?.dmStatement?.push == true
        isEmailSelected = accountOpeningDraft.value.statements?.dmStatement?.email == true
        robinsonSelected = accountOpeningDraft.value.statements?.dmStatement?.robinson

        if robinsonSelected == true {
            disableDMRBSingleOption = disableDMRBSingleOption.selecting(value: true)
        }
    }

    func handle(event: ConsentsDMStatementScreenInput) {
        switch event {
        case .proceed:
            let dmStatement = AccountOpeningDraft.Statements.DMStatement(push: isPushSelected,
                                                                         email: isEmailSelected,
                                                                         robinson: robinsonSelected ?? false)
            onProceedRequested?(dmStatement)
        case .skip:
            onProceedRequested?(nil)
        }
    }
}
