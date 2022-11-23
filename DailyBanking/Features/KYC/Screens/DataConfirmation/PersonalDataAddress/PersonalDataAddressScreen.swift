//
//  PersonalDataAddressScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 19..
//

import DesignKit
import SwiftUI

protocol PersonalDataAddressScreenViewModelProtocol: ObservableObject {
    var country: String { get }
    var address: String { get set }
    var addressState: ValidationState { get }
    var isNextButtonEnabled: Bool { get }
}

struct PersonalDataAddressScreen<ViewModel: PersonalDataAddressScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focusedField: String?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                Card {
                    VStack(spacing: .xxxl) {
                        DesignTextField(
                            title: Strings.Localizable.commonCountry,
                            text: .constant(viewModel.country),
                            validationState: .normal
                        )
                        .viewOnly(true, tapAction: { showToast() })

                        DesignTextField(
                            title: Strings.Localizable.personalDetailsAddress,
                            text: $viewModel.address,
                            hint: Strings.Localizable.accountSetupAddressAddressHint,
                            validationState: viewModel.addressState
                        )
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
        } floater: {
            DesignButton(
                title: Strings.Localizable.commonAllRight,
                action: {
                    dismiss()
                })
                .disabled(!viewModel.isNextButtonEnabled)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.secondary)
        .onTapGesture { hideKeyboard() }
        .analyticsScreenView("oao_data_address")
    }

    private func showToast() {
        Modals.toast.show(text: Strings.Localizable.commonDataNotEditable)
    }
}

private class MockPersonalDataAddressScreenViewModel: PersonalDataAddressScreenViewModelProtocol {
    var address: String = "This is my Address"
    var addressState: ValidationState = .normal
    var country: String = "Magyarország"
    var isNextButtonEnabled: Bool = true
}

struct PersonalDataAddressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            PersonalDataAddressScreen(viewModel: MockPersonalDataAddressScreenViewModel())
            .previewDevice(.init(rawValue: "iPhone 8"))
        }
    }
}
