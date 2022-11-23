//
//  ProfileScreen.swift
//  app-daily-banking-ios
//
//  Created by Zsombor Szabó on 2021. 09. 28..
//

import Combine
import DesignKit
import SwiftUI

enum BiometryInfo: Equatable {
    case notAvailable
    case available(imageName: String, title: String, isOn: Bool)
}

protocol ProfileScreenViewModelProtocol: ObservableObject {
    var userName: String { get }
    var initials: String { get }
    var versionText: String { get }
    var biometryInfo: BiometryInfo { get }
    var alert: AnyPublisher<AlertModel, Never> { get }
    var isLoading: Bool { get }

    func handle(_ event: ProfileScreenInput)
}

enum ProfileScreenInput {
    case personalInfo
    case monthlyStatements
    case contracts
    case biometrySwitch
    case changeMPin
    case logout
    case reset
}

struct ProfileScreen<ViewModel: ProfileScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            Color.background.secondary.ignoresSafeArea()
            List {
                Section(
                    header: Text(Strings.Localizable.profileOptionPersonal)
                        .textStyle(.headings5)
                        .foregroundColor(.text.tertiary)
                ) {
                    CardButton(
                        title: viewModel.userName,
                        subtitle: Strings.Localizable.profileOptionPersonalData,
                        leftView: AnyView(
                            MonogramView(
                                monogram: viewModel.initials,
                                size: .medium
                            )
                        ),
                        action: { viewModel.handle(.personalInfo) }
                    )
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Section(
                    header: Text(Strings.Localizable.profileOptionMyDocuments)
                        .textStyle(.headings5)
                        .foregroundColor(.text.tertiary)
                ) {
                    Card(padding: 0) {
                        CardButton(
                            cornerRadius: 0,
                            title: Strings.Localizable.profileOptionMonthlyAccountStatements,
                            image: Image(.fileDocument),
                            action: { viewModel.handle(.monthlyStatements) }
                        )
                        CardButton(
                            cornerRadius: 0,
                            title: Strings.Localizable.profileOptionContracts,
                            image: Image(.fileDocument),
                            action: { viewModel.handle(.contracts) }
                        )
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Section(
                    header: Text(Strings.Localizable.profileOptionSecurity)
                        .textStyle(.headings5)
                        .foregroundColor(.text.tertiary)
                ) {
                    Card(padding: 0) {
                        if case .available(let image, let title, let isOn) = viewModel.biometryInfo {
                            CardButton(
                                cornerRadius: 0,
                                title: title,
                                image: Image(image),
                                rightView: toggle(isOn),
                                supplementaryImage: nil,
                                action: { viewModel.handle(.biometrySwitch) }
                            )
                            .animation(.default, value: viewModel.biometryInfo)
                        }
                        CardButton(
                            cornerRadius: 0,
                            title: Strings.Localizable.profileOptionMpinChange,
                            image: Image(.passwordLock),
                            action: { viewModel.handle(.changeMPin) }
                        )
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Section(
                    header: Text(Strings.Localizable.profileOptionOther)
                        .textStyle(.headings5)
                        .foregroundColor(.text.tertiary)
                ) {
                    Card(padding: 0) {
                        CardButton(
                            cornerRadius: 0,
                            title: Strings.Localizable.profileOptionLogout,
                            image: Image(.logout),
                            supplementaryImage: nil,
                            action: { viewModel.handle(.logout) })
                        CardButton(
                            cornerRadius: 0,
                            title: Strings.Localizable.profileOptionReset,
                            image: Image(DesignKit.ImageName.remove),
                            style: .destructive,
                            supplementaryImage: nil,
                            action: { viewModel.handle(.reset) })
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

                HStack(spacing: 0) {
                    Spacer()
                    Text(viewModel.versionText)
                        .foregroundColor(Color.text.tertiary)
                        .textStyle(.body2)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
        .designAlert(viewModel.alert)
        .fullScreenProgress(by: viewModel.isLoading, name: "ProfileScreen")
        .hideContentBackground()
        .analyticsScreenView("profile")
    }

    func toggle(_ isOn: Bool) -> AnyView {
        AnyView(
            Toggle("", isOn: .constant(isOn))
                .toggleStyle(SwitchToggleStyle.init(tint: .highlight.tertiary))
                .fixedSize()
        )
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(viewModel: MockViewModel())
            .preferredColorScheme(.light)
    }
}

private class MockViewModel: ProfileScreenViewModelProtocol {
    var userName = "Ihász Zsolt"
    var initials = "IZ"
    var versionText = "1.0 (Build 4413)"
    var biometryInfo: BiometryInfo = .available(
        imageName: DesignKit.ImageName.faceId.rawValue,
        title: "Azonosítás Face ID-val",
        isOn: true
    )
    var alert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()
    var isLoading = false

    func handle(_ evet: ProfileScreenInput) {}
}
