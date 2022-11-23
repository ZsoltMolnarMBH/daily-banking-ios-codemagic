//
//  ProfileScreenViewModel.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 07..
//

import Combine
import Foundation
import LocalAuthentication
import Resolver
import SwiftUI
import DesignKit

enum ProfileScreenResult {
    case personalInfoRequested
    case monthlyStatementsRequested
    case contractsRequested
    case changeMPinRequested
    case toggleBiometricAuthRequested
}

class ProfileScreenViewModel: ScreenViewModel<ProfileScreenResult>, ProfileScreenViewModelProtocol {
    @Published var userName: String = ""
    @Published var initials: String = ""
    @Published var versionText: String = ""
    @Published var biometryInfo: BiometryInfo = .notAvailable
    @Published var isLoading = false
    private var alertSubject = PassthroughSubject<AlertModel, Never>()
    var alert: AnyPublisher<AlertModel, Never> {
        alertSubject.eraseToAnyPublisher()
    }
    private var isResetting = CurrentValueSubject<Bool, Never>(false)

    @Injected private var pinStore: BiometricAuthStore
    @Injected private var user: ReadOnly<User?>
    @Injected private var userAction: UserAction
    @Injected private var resetAction: ResetAction
    @Injected private var appInfo: AppInformation

    private var authContext = LAContext.new
    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        user.publisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] (user: User) in
                self?.userName = user.name.localizedName
                self?.initials = user.name.initials
            }
            .store(in: &disposeBag)

        pinStore
            .isPinCodeSaved
            .replaceError(with: false)
            .map { [authContext] isSaved -> BiometryInfo in
                if authContext.biometryAvailability == .notAvailable {
                    return .notAvailable
                }
                let isOn = isSaved
                    && (authContext.biometryAvailability == .available || authContext.biometryAvailability == .biometryLocked)
                let title = authContext.biometryType == .faceID ?
                    Strings.Localizable.profileOptionBiometryFaceid : Strings.Localizable.profileOptionBiometryTouchid
                let image: DesignKit.ImageName = authContext.biometryType == .faceID ? .faceId : .fingerprint
                return .available(imageName: image.rawValue, title: title, isOn: isOn)
            }
            .assign(to: \.biometryInfo, onWeak: self)
            .store(in: &disposeBag)

        isResetting
            .assign(to: &$isLoading)

        versionText = appInfo.detailedVersion
    }

    func handle(_ event: ProfileScreenInput) {
        switch event {
        case .personalInfo:
            events.send(.personalInfoRequested)
        case .monthlyStatements:
            events.send(.monthlyStatementsRequested)
        case .contracts:
            events.send(.contractsRequested)
        case .biometrySwitch:
            events.send(.toggleBiometricAuthRequested)
        case .changeMPin:
            events.send(.changeMPinRequested)
        case .logout:
            logout()
        case .reset:
            confirmReset()
        }
    }

    private func confirmReset() {
        let alert = AlertModel(
            title: Strings.Localizable.appResetDialogTitle,
            imageName: .warningSemantic,
            subtitle: AttributedString(Strings.Localizable.appResetDialogDescription),
            actions: [
                .init(title: Strings.Localizable.commonCancel, kind: .primary, handler: {}),
                .init(title: Strings.Localizable.commonContinue, kind: .secondary, handler: { [weak self] in self?.reset() })
            ]
        )
        alertSubject.send(alert)
    }

    private func logout() {
        userAction
            .logout()
            .sink(receiveCompletion: { _ in })
            .store(in: &disposeBag)
    }

    private func reset() {
        isResetting.send(true)
        resetAction
            .reset()
            .sink(receiveCompletion: { [alertSubject, isResetting] completion in
                isResetting.send(false)
                switch completion {
                case .finished:
                    break
                case .failure:
                    alertSubject.send(.genericError())
                }
            })
            .store(in: &disposeBag)
    }
}
