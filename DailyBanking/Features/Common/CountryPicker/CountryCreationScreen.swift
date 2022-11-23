//
//  AddNewCountryScreen.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 06..
//

import SwiftUI
import DesignKit

protocol CountryCreationScreenViewModelProtocol: ObservableObject {
    var countryName: String { get set }
    var countryNameState: ValidationState { get set }
    var isSaveDisabled: Bool { get }

    func handle(event: CountryCreationScreenInput)
}

enum CountryCreationScreenInput {
    case save
}

struct CountryCreationScreen<ViewModel: CountryCreationScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack {
                Card {
                    DesignTextField(
                        title: Strings.Localizable.commonCountry,
                        text: $viewModel.countryName,
                        validationState: viewModel.countryNameState
                    )
                    .hideErrorWhileEditing(true)
                }
                Spacer()
            }
            .padding()
        } floater: {
            DesignButton(
                style: .primary,
                title: Strings.Localizable.commonAllRight) {
                    viewModel.handle(event: .save)
                }
                .disabled(viewModel.isSaveDisabled)
        }
        .floaterAttachedToKeyboard(true)
    }
}
