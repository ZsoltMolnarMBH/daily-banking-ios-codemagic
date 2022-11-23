//
//  ProxyIdConfirmationScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 12..
//

import SwiftUI
import DesignKit
import Combine

protocol ProxyIdConfirmationScreenViewModelProtocol: ObservableObject {
    var kind: String { get }
    var value: String { get }
    var hint: String { get }
    var isPrivacyNoticeAccepted: Bool { get set }
    var isConfirmationAvailable: Bool { get }
    var isLoading: Bool { get }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }
    func handle(event: ProxyIdConfirmationScreenInput)
}

enum ProxyIdConfirmationScreenInput {
    case privacyPolicy
    case confirm
}

struct ProxyIdConfirmationScreen<ViewModel: ProxyIdConfirmationScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: 16) {
                CardInfo(
                    title: viewModel.kind,
                    subtitle: viewModel.value
                )
                CheckBoxRow(
                    isChecked: $viewModel.isPrivacyNoticeAccepted,
                    text: Strings.Localizable.secondaryIdAcceptTermsMd
                )
                .onLinkTapped { _ in
                    viewModel.handle(event: .privacyPolicy)
                }

                Text(viewModel.hint)
                    .textStyle(.body1)
                    .foregroundColor(.text.tertiary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
            Spacer()
        } floater: {
            DesignButton(title: Strings.Localizable.commonAdd) {
                viewModel.handle(event: .confirm)
            }
            .disabled(!viewModel.isConfirmationAvailable)
        }
        .designAlert(viewModel.bottomAlert)
        .fullScreenProgress(by: viewModel.isLoading, name: "proxyidConfirmation")
    }
}

struct ProxyIdValueInputScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProxyIdConfirmationScreen<MockProxyIdConfirmationScreenViewModel>(viewModel: .init())
            .preferredColorScheme(.light)
    }
}

class MockProxyIdConfirmationScreenViewModel: ProxyIdConfirmationScreenViewModelProtocol {
    var kind: String = ProxyId.Kind.phoneNumber.localized
    var value: String = "+36201234567".formatted(pattern: .phoneNumberWithCountryCode)
    var hint: String = Strings.Localizable.accountDetailsSecondaryIdAddDescription

    @Published var isPrivacyNoticeAccepted: Bool = false
    var isConfirmationAvailable: Bool {
        isPrivacyNoticeAccepted
    }
    @Published var isLoading: Bool = false
    var bottomAlert: AnyPublisher<AlertModel, Never>  = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()

    func handle(event: ProxyIdConfirmationScreenInput) {
        // Nothing to do in mock
    }
}
