//
//  AddNewCountryScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 06..
//

import SwiftUI
import DesignKit
import Combine

class CountryCreationScreenViewModel: CountryCreationScreenViewModelProtocol {

    @Published var countryName: String = ""
    @Published var countryNameState: ValidationState = .normal
    var isSaveDisabled: Bool = true

    private var disposeBag: Set<AnyCancellable> = .init()
    private let countryCreationDescriptor: CountryCreationDescriptor
    private let dismisssAction: () -> Void
    private let countrySelectedAction: (Country) -> Void

    init(countryCreationDescriptor: CountryCreationDescriptor, onCountrySelected: @escaping (Country) -> Void, dismissAction: @escaping () -> Void) {
        self.countryCreationDescriptor = countryCreationDescriptor
        self.countrySelectedAction = onCountrySelected
        self.dismisssAction = dismissAction

        $countryName
            .dropFirst()
            .map {
                $0.trimmingCharacters(in: .whitespaces).isEmpty
                ? .error(text: Strings.Localizable.countryPickerCountryNameCannotBeEmpty)
                : .normal
            }
            .assign(to: \.countryNameState, onWeak: self)
            .store(in: &disposeBag)

        $countryNameState
            .dropFirst()
            .map {
                switch $0 {
                case .normal, .loading, .validated, .warning:
                    return false
                case .error:
                    return true
                }
            }
            .assign(to: \.isSaveDisabled, onWeak: self)
            .store(in: &disposeBag)

        if countryCreationDescriptor.defaultValue.code.isEmpty, !countryCreationDescriptor.defaultValue.name.isEmpty {
            countryName = countryCreationDescriptor.defaultValue.name
        }
    }

    func handle(event: CountryCreationScreenInput) {
        switch event {
        case .save:
            countrySelectedAction(.init(code: "", name: countryName))
            dismisssAction()
        }
    }
}
