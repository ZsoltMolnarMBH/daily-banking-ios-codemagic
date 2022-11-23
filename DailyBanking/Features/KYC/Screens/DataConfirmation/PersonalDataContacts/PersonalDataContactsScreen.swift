//
//  ContactsScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 16..
//

import SwiftUI
import DesignKit

protocol PersonalDataContactsScreenViewModelProtocol: ObservableObject {
    var phoneNumber: String { get set }
    var email: String { get set }
}

struct PersonalDataContactsScreen<ViewModel: PersonalDataContactsScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                Card {
                    DesignTextField(
                        title: Strings.Localizable.personalDetailsPhoneNumber,
                        text: $viewModel.phoneNumber,
                        validationState: .normal
                    )
                    .viewOnly(true, tapAction: { showToast() })

                    DesignTextField(
                        title: Strings.Localizable.accountSetupContactsEmail,
                        text: $viewModel.email,
                        validationState: .normal
                    )
                    .viewOnly(true, tapAction: { showToast() })
                }
                Spacer()
            }
            .padding()
        } floater: {
            DesignButton(
                title: Strings.Localizable.commonAllRight,
                action: {
                    dismiss()
                })
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.secondary)
        .analyticsScreenView("oao_data_contact_details")
    }

    private func showToast() {
        Modals.toast.show(text: Strings.Localizable.commonDataNotEditable)
    }
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDataContactsScreen(viewModel: MockPersonalDataContactsScreenViewModel())
    }
}

private class MockPersonalDataContactsScreenViewModel: PersonalDataContactsScreenViewModelProtocol {
    var phoneNumber: String = "+36 20 3 203 206"
    var email = "test@jmail.com"
}
