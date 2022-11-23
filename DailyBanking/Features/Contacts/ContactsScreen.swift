//
//  ContactsScreen.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 13..
//

import DesignKit
import SwiftUI

struct ContactsScreen<ViewModel: ContactsScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FullHeightScrollView {
            VStack(spacing: .m) {
                VStack(spacing: .m) {
                    Image(.brandLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding([.leading, .trailing, .bottom], .xl)
                    Text(Strings.Localizable.contactDescription)
                        .textStyle(.body1)
                        .multilineTextAlignment(.center)
                }
                .padding(.xxxl)
                VStack(spacing: .m) {
                    CardButton(
                        title: Strings.Localizable.contactEmailLabel,
                        subtitle: viewModel.email,
                        image: Image(.messageUnread),
                        supplementaryImage: nil) {
                            viewModel.handle(event: .emailPressed)
                        }
                    CardButton(
                        title: Strings.Localizable.contactSendFeedback,
                        image: Image(.chat),
                        supplementaryImage: nil) {
                            viewModel.handle(event: .sendFeedback)
                        }
                }
                DesignButton(
                    style: .tertiary,
                    title: Strings.Localizable.featureInfoTitle) {
                        viewModel.handle(event: .contactInfoPressed)
                    }
                    .padding(.top, .m)
                Spacer()
            }
            .padding(.m)
            Spacer()
        }
        .background(Color.background.secondary)
        .analyticsScreenView("contact")
    }
}

struct ContactsPreviews: PreviewProvider {
    static var previews: some View {
        ContactsScreen(viewModel: MockContactsScreenViewModel())
            .preferredColorScheme(.dark)
    }
}

class MockContactsScreenViewModel: ContactsScreenViewModelProtocol {
    var email: String = "segitseg@magyarbankholding.hu"

    func handle(event: ContactsScreenInput) {}
}
