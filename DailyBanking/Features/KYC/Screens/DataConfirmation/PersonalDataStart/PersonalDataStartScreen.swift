//
//  PersonalDataStartScreen.swift
//  app-daily-banking-ios
//
//  Created by Alexa Mark on 2021. 11. 15..
//

import Combine
import SwiftUI
import DesignKit

protocol PersonalDataStartScreenViewModelProtocol: ObservableObject {
    var isNextDisabled: Bool { get }
    var isLoading: Bool { get }
    var contactsCardState: CardButton.ImageBadge? { get }
    var personalDataCardState: CardButton.ImageBadge? { get }
    var addressCardState: CardButton.ImageBadge? { get }
    var documentsCardState: CardButton.ImageBadge? { get }

    func handle(event: PersonalDataStartScreenInput)
}

enum PersonalDataStartScreenInput {
    case onAppear
    case contacts
    case personalData
    case address
    case documents
    case info
    case next
}

struct PersonalDataStartScreen<ViewModel: PersonalDataStartScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                VStack(alignment: .leading, spacing: .xs) {
                    Text(Strings.Localizable.accountSetupMainPageQuestion)
                        .textStyle(.headings5)
                        .foregroundColor(.text.tertiary)
                    Text(Strings.Localizable.accountSetupMainPageDescription)
                        .textStyle(.body2)
                        .foregroundColor(.text.secondary)
                }
                VStack(spacing: .m) {
                    CardButton(
                        title: Strings.Localizable.accountSetupMainPageContacts,
                        image: Image(.phone),
                        imageBadge: viewModel.contactsCardState
                    ) {
                        viewModel.handle(event: .contacts)
                    }
                    CardButton(
                        title: Strings.Localizable.accountSetupMainPagePersonalData,
                        image: Image(.user),
                        imageBadge: viewModel.personalDataCardState
                    ) {
                        viewModel.handle(event: .personalData)
                    }
                    CardButton(
                        title: Strings.Localizable.accountSetupMainPageAddress,
                        image: Image(.home),
                        imageBadge: viewModel.addressCardState
                    ) {
                        viewModel.handle(event: .address)
                    }
                    CardButton(
                        title: Strings.Localizable.accountSetupMainPageDocuments,
                        image: Image(.id),
                        imageBadge: viewModel.documentsCardState
                    ) {
                        viewModel.handle(event: .documents)
                    }
                }
                Spacer()
            }
            .padding(.m)
            .padding(.top, .xxxl)
        } floater: {
            DesignButton(
                style: .primary,
                size: .large,
                title: Strings.Localizable.accountSetupMainPageConfirmData
            ) {
                viewModel.handle(event: .next)
            }
            .disabled(viewModel.isNextDisabled)
        }
        .fullScreenProgress(by: viewModel.isLoading, name: "personalData")
        .navigationBarItems(trailing:
            Button(
                action: {
                    analytics.logButtonPress(contentType: "help icon", componentLabel: nil)
                    viewModel.handle(event: .info)
                },
                label: {
                    Image(.help)
                        .foregroundColor(.action.tertiary.default)
                }
            )
        )
        .navigationTitle(Strings.Localizable.accountSetupMainPageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.secondary)
        .onAppear {
            viewModel.handle(event: .onAppear)
        }
    }
}

struct PersonalDataStartScreen_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDataStartScreen(viewModel: MockPersonalDataStartScreenViewModel())
    }
}

private class MockPersonalDataStartScreenViewModel: PersonalDataStartScreenViewModelProtocol {
    var contactsCardState: CardButton.ImageBadge? = .checked
    var personalDataCardState: CardButton.ImageBadge? = .checked
    var addressCardState: CardButton.ImageBadge? = .error
    var documentsCardState: CardButton.ImageBadge? = .checked

    var isNextDisabled: Bool = false
    var isLoading: Bool = false

    func handle(event: PersonalDataStartScreenInput) {}
}
