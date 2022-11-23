//
//  ConsentsDocumentScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 08..
//

import DesignKit
import SwiftUI

enum ConsentsDocumentScreenInput {
    case proceed
    case openConditions
    case openTerms
    case openPrivacyPolicy
}

protocol ConsentsDocumentsScreenViewModelProtocol: ObservableObject {
    var isValidated: Bool { get }
    var isConditionsAccepted: Bool { get set }
    var isTermsAccepted: Bool { get set }
    var isPrivacyPolicyAccepted: Bool { get set }

    func handle(event: ConsentsDocumentScreenInput)
}

struct ConsentsDocumentScreen<ViewModel: ConsentsDocumentsScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    private let conditions = Strings.Localizable.consentsConditionsConditionsMd
    private let business = Strings.Localizable.consentsConditionsTermsMd
    private let privacy = Strings.Localizable.consentsConditionsPrivacyPolicyMd

    var body: some View {
        FormLayout {
            Card {
                VStack(alignment: .leading, spacing: .xl) {
                    Text(Strings.Localizable.consentsConditionsDescription)
                        .textStyle(.headings5)
                        .foregroundColor(.text.primary)
                        .padding(.bottom, .xs)

                    CheckBoxRow(
                        isChecked: $viewModel.isConditionsAccepted,
                        text: conditions
                    )
                    .onLinkTapped { _ in
                        viewModel.handle(event: .openConditions)
                    }
                    .padding(.bottom, .xs)

                    CheckBoxRow(
                        isChecked: $viewModel.isTermsAccepted,
                        text: business
                    )
                    .onLinkTapped { _ in
                        viewModel.handle(event: .openTerms)
                    }
                    .padding(.bottom, .xs)

                    CheckBoxRow(
                        isChecked: $viewModel.isPrivacyPolicyAccepted,
                        text: privacy
                    )
                    .onLinkTapped { _ in
                        viewModel.handle(event: .openPrivacyPolicy)
                    }
                    .padding(.bottom, .xs)
                }
            }
            .padding()
            Spacer()
        } floater: {
            DesignButton(
                style: .primary,
                size: .large,
                title: Strings.Localizable.commonAllRight
            ) {
                viewModel.handle(event: .proceed)
            }
            .disabled(!viewModel.isValidated)
        }
    }
}
