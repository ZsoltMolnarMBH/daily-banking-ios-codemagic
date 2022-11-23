//
//  CountryPickerScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 12..
//

import Foundation
import SwiftUI
import Combine

class CountryPickerScreenViewModel: CountryPickerScreenViewModelProtocol {

    @Published var countries: [Country] = []
    @Published var searchText: String = ""
    let countryCreationDescriptor: CountryCreationDescriptor?
    let dismissAction: () -> Void
    let countrySelectedAction: (Country) -> Void

    private var allCountries: [Country] = []
    private var disabledCountryCodes: [String]
    private var disposeBag = Set<AnyCancellable>()

    init(disabledCountryCodes: [String], countryCreationDescriptor: CountryCreationDescriptor?, onCountrySelected: @escaping (Country) -> Void, dismissAction: @escaping () -> Void) {
        self.disabledCountryCodes = disabledCountryCodes
        self.countryCreationDescriptor = countryCreationDescriptor
        self.dismissAction = dismissAction
        self.countrySelectedAction = onCountrySelected
        self.populate()
        self.allCountries = countries

        $searchText
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.countries = searchText.isEmpty ? self.allCountries : self.allCountries.filter { $0.name.contains(searchText) }
            }
            .store(in: &disposeBag)
    }

    func populate() {
        for localeCode in NSLocale.isoCountryCodes {
            if let localeName = NSLocale.countryName(for: localeCode) {
                countries.append(.init(code: localeCode, name: localeName))
            }
        }
        let currentRegionCode = Locale.current.regionCode
        countries.sort {
            if $0.code == currentRegionCode { return true }
            if $1.code == currentRegionCode { return false }
            return $0.name < $1.name
        }
    }

    func isDisabled(country: Country) -> Bool {
        !disabledCountryCodes.filter { $0.lowercased() == country.code.lowercased() }.isEmpty
    }

    func handle(event: CountryPickerScreenInput) {
        switch event {
        case .select(let country):
            countrySelectedAction(country)
            dismissAction()
        }
    }
}
