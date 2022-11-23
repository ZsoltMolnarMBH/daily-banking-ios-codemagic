//
//  PersonalInfoScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 16..
//

import SwiftUI
import DesignKit

protocol PersonalInfoScreenViewModelProtocol: ObservableObject {
    var name: String { get }
    var birthDate: String { get }
    var address: String { get }
    var phoneNumber: String { get }
    var emailAddress: String { get }
    var isLoading: Bool { get }
    var personalInfoFetchErrorModel: ResultModel? { get }

    func handle(_ event: PersonalInfoScreenInput)
}

enum PersonalInfoScreenInput {
    case onAppear
    case editingInfo
}

struct PersonalInfoScreen<ViewModel: PersonalInfoScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .m) {
                CardInfo(
                    title: Strings.Localizable.personalDetailsName,
                    subtitle: viewModel.name
                )
                CardInfo(
                    title: Strings.Localizable.personalDetailsBirthDate,
                    subtitle: viewModel.birthDate
                )
                CardInfo(
                    title: Strings.Localizable.personalDetailsAddress,
                    subtitle: viewModel.address
                )
                CardInfo(
                    title: Strings.Localizable.personalDetailsPhoneNumber,
                    subtitle: viewModel.phoneNumber
                )
                CardInfo(
                    title: Strings.Localizable.personalDetailsEmail,
                    subtitle: viewModel.emailAddress
                )
                DesignButton(
                    style: .tertiary,
                    title: Strings.Localizable.personalDetailsButtonTitle,
                    action: {
                        viewModel.handle(.editingInfo)
                    }
                )
            }
            .onAppear {
                viewModel.handle(.onAppear)
            }
            .shimmeringPlaceholder(
                when: viewModel.isLoading,
                for: Color.background.secondary
            )
            .animation(.default, value: viewModel.isLoading)
            .padding(.m)
        }
        .background(Color.background.secondary)
        .analyticsScreenView("personal_data")
        .fullscreenResult(model: viewModel.personalInfoFetchErrorModel, shouldHideNavbar: false)
    }
}

struct PersonalInfoPreviews: PreviewProvider {
    static var previews: some View {
        PersonalInfoScreen(viewModel: MockViewModel())
    }
}

private class MockViewModel: PersonalInfoScreenViewModelProtocol {

    var name: String = "Ihász Zsolt"
    var birthDate: String = "1983 december 27."
    var address: String = "1084 Budapest\nRátz László u. 9."
    var phoneNumber: String = "+36 30 305 16 13"
    var emailAddress: String = "zsolt.ihasz@gmail.com"
    var isLoading: Bool = true
    var personalInfoFetchErrorModel: ResultModel?

    func handle(_ event: PersonalInfoScreenInput) {}
}
