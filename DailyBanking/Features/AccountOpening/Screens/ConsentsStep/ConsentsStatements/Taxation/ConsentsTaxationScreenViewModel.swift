//
//  ConsentsTaxationScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 08..
//

import Foundation
import Combine
import Resolver
import SwiftUI

protocol ConsentsTaxationScreenListener: AnyObject {
    func selectTaxationCountry(disabledCountryCodes: [String])
}

class ConsentsTaxationScreenViewModel: ConsentsTaxationViewModelProtocol {
    @Injected var accountOpeningDraft: ReadOnly<AccountOpeningDraft>

    @Published var selectedTaxResidency: Consent.TaxResidency?
    @Published var taxation: [Consent.Taxation] = []
    @Published var isValidated: Bool = false

    var disabledCountryCodes: [String] { taxation.compactMap { $0.country.code } + [hungaryCountryCode] }
    var selectedTaxationIndex: Int = 0
    var taxResidencyPickerDataSet: [(String, Consent.TaxResidency)] = [
        (Consent.TaxResidency.hungary.label, .hungary),
        (Consent.TaxResidency.hungaryAbroad.label, .hungaryAbroad),
        (Consent.TaxResidency.abroad.label, .abroad)
    ]
    var onProceedRequested: (([AccountOpeningDraft.Statements.Taxation], Consent.TaxResidency?) -> Void)?

    weak var screenListener: ConsentsTaxationScreenListener?

    private let hungaryCountryCode = "hu"
    private var disposeBag = Set<AnyCancellable>()

    init() {
        $taxation
            .map { [weak self] in
                self?.updateTaxNumberValidationStates()
                return self?.isTaxationValid($0) ?? false
            }
            .assign(to: \.isValidated, onWeak: self)
            .store(in: &disposeBag)

        accountOpeningDraft.publisher.dropFirst().compactMap {
            $0.selectedCountry
        }.removeDuplicates().sink { [weak self] selectedCountry in
            guard let self = self, self.selectedTaxationIndex < self.taxation.count else { return }

            let originalTaxation = self.taxation[self.selectedTaxationIndex]
            self.taxation[self.selectedTaxationIndex] = .init(
                country: selectedCountry,
                taxNumber: originalTaxation.taxNumber
            )
        }.store(in: &disposeBag)

        populate(with: accountOpeningDraft.value)
    }

    func handle(event: ConsentsTaxationScreenInput) {
        switch event {
        case .taxationResidencySelected(let selectedResidency):
            handleSelectedResidency(selectedResidency)
        case .removeTaxation(let tmpTaxation):
            taxation.remove(element: tmpTaxation)
        case .addEmptyTaxation:
            taxation.append(.init())
        case .proceed:
            onProceedRequested?(makeTaxation(), selectedTaxResidency)
        case .presentCountryPicker:
            screenListener?.selectTaxationCountry(disabledCountryCodes: disabledCountryCodes)
        }
    }

    private func populate(with accountOpeningDraft: AccountOpeningDraft) {
        guard let statementsDraft = accountOpeningDraft.statements else { return }
        selectedTaxResidency = statementsDraft.taxResidency
        taxation = statementsDraft
            .taxation
            .filter { [hungaryCountryCode] in $0.country != hungaryCountryCode }
            .map {
                .init(
                    country: .init(code: $0.country, name: NSLocale.countryName(for: $0.country) ?? ""),
                    taxNumber: $0.taxNumber
                )
            }
    }

    private func handleSelectedResidency(_ selectedResidency: Consent.TaxResidency) {
        selectedTaxResidency = selectedResidency
        guard let selectedTaxationResidency = selectedTaxResidency else { return }
        switch selectedTaxationResidency {
        case .hungary:
            taxation.removeAll()
        case .hungaryAbroad, .abroad:
            if taxation.isEmpty {
                taxation.append(.init())
            }
        }
    }

    private func updateTaxNumberValidationStates() {
        _ = taxation.map { tmpTaxation -> Consent.Taxation in
            let taxNumber = tmpTaxation.taxNumber
            tmpTaxation.taxNumberValidationState = taxNumber.isEmpty ?
                .error(text: Strings.Localizable.accountOpeningTaxResidencyAbroadTaxError) : .normal
            return tmpTaxation
        }
    }

    private func isTaxationValid(_ taxation: [Consent.Taxation]) -> Bool {
        switch selectedTaxResidency {
        case .hungary: return true
        case .hungaryAbroad, .abroad:
            return taxation.filter { !$0.country.code.isEmpty && !$0.taxNumber.isEmpty }.count == taxation.count
        default:
            return false
        }
    }

    private func makeTaxation() -> [AccountOpeningDraft.Statements.Taxation] {
       var result = taxation
            .filter {
                guard !$0.taxNumber.isEmpty, !$0.country.code.isEmpty else { return false }
                return true
            }
            .map { AccountOpeningDraft.Statements.Taxation(country: $0.country.code, taxNumber: $0.taxNumber) }
        if selectedTaxResidency != .abroad {
            result.append(.init(country: hungaryCountryCode, taxNumber: ""))
        }
        return result
    }
}
