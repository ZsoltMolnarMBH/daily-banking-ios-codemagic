//
//  PersonalDataDocumentsScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 19..
//

import DesignKit
import SwiftUI

protocol PersonalDataDocumentsScreenViewModelProtocol: ObservableObject {
    var idType: String { get }
    var idNumber: String { get set }
    var idNumberState: ValidationState { get }
    var isIdNumberEditable: Bool { get }

    var validity: Date? { get set }
    var validityState: ValidationState { get }
    var isValidityEditable: Bool { get }

    var addressCardNumber: String { get set }
    var addressCardNumberState: ValidationState { get }
    var isAddressCardNumberEditable: Bool { get }

    var isNextButtonEnabled: Bool { get }
}

struct PersonalDataDocumentsScreen<ViewModel: PersonalDataDocumentsScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss

    @State private var date = Date()
    @FocusState private var focusedField: Field?
    enum Field: Int, Hashable {
        case idNumber
        case addressCardNumber
    }

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                Card {
                    VStack(spacing: .xxxl) {
                        DesignTextField(
                            title: Strings.Localizable.accountSetupDocumentsType,
                            text: .constant(viewModel.idType),
                            validationState: .normal
                        )
                        .viewOnly(true, tapAction: { showToast() })

                        DesignTextField(
                            title: Strings.Localizable.accountSetupDocumentsNumber,
                            text: $viewModel.idNumber,
                            validationState: viewModel.idNumberState
                        )
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .viewOnly(!viewModel.isIdNumberEditable, tapAction: { showToast() })
                        .focused($focusedField, equals: .idNumber)
                        .onSubmit { focusNextField($focusedField) }

                        DesignDatePicker(
                            title: Strings.Localizable.accountSetupDocumentsValidity,
                            date: $viewModel.validity,
                            state: viewModel.validityState
                        )
                        .dateFormatter(.userFacing)
                        .viewOnly(!viewModel.isValidityEditable, tapAction: { showToast() })
                    }
                }
                Card {
                    VStack(spacing: 0) {
                        DesignTextField(
                            title: Strings.Localizable.accountSetupDocumentsAddressCardNumber,
                            text: $viewModel.addressCardNumber,
                            validationState: viewModel.addressCardNumberState
                        )
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .viewOnly(!viewModel.isAddressCardNumberEditable, tapAction: { showToast() })
                        .focused($focusedField, equals: .addressCardNumber)
                        .onSubmit { focusNextField($focusedField) }
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
        .analyticsScreenView("oao_data_documents")
    }

    private func showToast() {
        Modals.toast.show(text: Strings.Localizable.commonDataNotEditable)
    }
}

private class MockPersonalDataDocumentsScreenViewModel: PersonalDataDocumentsScreenViewModelProtocol {
    var isNextButtonEnabled: Bool = false
    var isIdNumberEditable: Bool = false
    var isValidityEditable: Bool = false
    var isAddressCardNumberEditable: Bool = true
    var idType: String = "Személyi igazolvány"
    var idNumber = "123456AA"
    var idNumberState: ValidationState = .normal
    var addressCardNumber = "123456AS"
    var addressCardNumberState: ValidationState = .normal
    var validity: Date? = .now
    var validityState: ValidationState = .normal
}

struct PersonalDataDocumentsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            PersonalDataDocumentsScreen(viewModel: MockPersonalDataDocumentsScreenViewModel())
        }
    }
}
