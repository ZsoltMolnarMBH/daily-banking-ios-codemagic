//
//  PackageDetailsScreen.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 11. 29..
//

import SwiftUI
import DesignKit

protocol PackageDetailsScreenViewModelProtocol: ObservableObject {
    var actionButtonTitle: String { get }
    var visibleDocuments: [LegalDocumentType] { get }

    func handle(_ event: PackageDetailsScreenInput)
}

enum PackageDetailsScreenInput {
    case actionButtonPressed
    case documentPressed(documentType: LegalDocumentType)
}

struct PackageDetailsScreen<ViewModel: PackageDetailsScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            Card(padding: 0) {
                VStack(spacing: 0) {
                    Text(Strings.Localizable.accountOpeningPackageDetailsName)
                        .textStyle(.headings3)
                        .foregroundColor(.text.primary)
                    Text(Strings.Localizable.accountOpeningPackageDetailsDescription)
                        .textStyle(.headings6)
                        .foregroundColor(.text.tertiary)
                        .padding(.top, .xs)
                    HStack {
                        Text(Strings.Localizable.accountOpeningPackageDetailsSubtitle)
                            .textStyle(.body3)
                            .foregroundColor(.text.secondary)
                        Spacer()
                    }
                    .padding(.top, .xl)
                    .padding([.leading, .trailing], .m)
                    VStack(alignment: .leading, spacing: .xs) {
                        InfoView(
                            title: Strings.Localizable.accountOpeningPackageDetailsFeature1,
                            text: Strings.Localizable.accountOpeningPackageDetailsFeatureComingSoon
                        )
                        .titleColor(.text.secondary)
                        .titleStyle(.headings6)
                        .textColor(.text.tertiary)
                        .textStyle(.body3)

                        InfoView(
                            title: Strings.Localizable.accountOpeningPackageDetailsFeature2,
                            text: Strings.Localizable.accountOpeningPackageDetailsFeatureComingSoon
                        )
                        .titleColor(.text.secondary)
                        .titleStyle(.headings6)
                        .textColor(.text.tertiary)
                        .textStyle(.body3)

                        InfoView(
                            title: Strings.Localizable.accountOpeningPackageDetailsFeature3,
                            text: Strings.Localizable.accountOpeningPackageDetailsFeatureComingSoon
                        )
                        .titleColor(.text.secondary)
                        .titleStyle(.headings6)
                        .textColor(.text.tertiary)
                        .textStyle(.body3)
                    }
                    .padding()
                    VStack(alignment: .leading, spacing: .xs) {
                        Text(Strings.Localizable.accountOpeningPackageMoreDetailsDocuments)
                            .textStyle(.headings5)
                            .foregroundColor(.text.tertiary)
                            .padding(.leading, .m)
                        ForEach(viewModel.visibleDocuments, id: \.title) { legalDocument in
                            CardButton(
                                cornerRadius: 0,
                                title: legalDocument.title,
                                image: Image(.document),
                                style: .secondary
                            ) {
                                viewModel.handle(.documentPressed(documentType: legalDocument))
                            }
                        }
                    }
                    .padding(.top, .m)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, .m)
            }
            .padding()
            Spacer()
        } floater: {
            DesignButton(style: .primary, title: viewModel.actionButtonTitle) {
                viewModel.handle(.actionButtonPressed)
            }
        }
        .background(Color.background.secondary)
    }
}

struct AccountPackageDetailsScreenPreview: PreviewProvider {
    static var previews: some View {
        PackageDetailsScreen(viewModel: MockViewModel())
            .preferredColorScheme(.light)
    }
}

private class MockViewModel: PackageDetailsScreenViewModelProtocol {
    var actionButtonTitle: String = "Button title"
    var visibleDocuments: [LegalDocumentType] = [
        .conditionList,
        .contractTemplate,
        .privacyStatement
    ]

    func handle(_ event: PackageDetailsScreenInput) {}
}
