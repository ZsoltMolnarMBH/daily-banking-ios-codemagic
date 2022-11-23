//
//  BiometrySetupScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 10..
//

import Combine
import SwiftUI
import Resolver
import LocalAuthentication

protocol BiometrySetupScreenListener: AnyObject {
    func skipRequested()
    func settingsRequested()
    func onBiometrySetupFinished()
    func generalHelpRequested()
    func multiBiometricUsageHelpRequested()
}

class BiometrySetupScreenViewModel: BiometrySetupScreenViewModelProtocol {

    weak var listener: BiometrySetupScreenListener?

    @Published var isBiometryAvailable: Bool = true
    @Published var biometryImage: ImageName = .touchId
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var subtitle: String = ""
    @Published var multiBiomentricHelpButtonTitle: String = ""
    @Published var isPermissionGranted: Bool = true
    @Published var analyticsName: String = ""
    @Published var alert: AlertModel?

    var pinCode: PinCode?
    private var disposeBag = Set<AnyCancellable>()
    private var biometryAvailability: LAContext.BiometryAvailability = .notAvailable

    @Injected var pinStore: BiometricAuthStore

    init() {
        setup()

        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.willEnterForegroundNotification
        ).sink { [weak self] _ in
            self?.setup()
        }
        .store(in: &disposeBag)
    }

    func handle(event: BiometrySetupScreenInputs) {
        switch event {
        case .skip:
            listener?.skipRequested()
        case .start:
            storePin()
        case .generalHelp:
            listener?.generalHelpRequested()
        case .multpleBiometricHelp:
            listener?.multiBiometricUsageHelpRequested()
        case .goSettings:
            listener?.settingsRequested()
        }
    }

    private func setup() {
        let authContext = LAContext.new
        biometryAvailability = authContext.biometryAvailability
        switch biometryAvailability {
        case .available, .biometryLocked:
            isBiometryAvailable = true
            if authContext.biometryType == .faceID {
                setupForFaceID()
            } else {
                setupForTouchID()
            }
        case .permissionDenied:
            listener?.skipRequested()
        case .disabledOSLevel, .notAvailable:
            isBiometryAvailable = false
            analyticsName = "biometric_setup"
        }
    }

    private func setupForFaceID() {
        biometryImage = .faceid
        title = Strings.Localizable.biometryFaceidSetupTitle
        message = Strings.Localizable.biometryFaceidSetupSubtitle1
        subtitle = Strings.Localizable.biometryFaceidSetupSubtitle2
        multiBiomentricHelpButtonTitle = Strings.Localizable.biometryMultipleFaceidInfoTitle
        analyticsName = "faceid_setup"
    }

    private func setupForTouchID() {
        biometryImage = .touchId
        title = Strings.Localizable.biometryTouchidSetupTitle
        message = Strings.Localizable.biometryFingerprintSetupSubtitle1
        subtitle = Strings.Localizable.biometryFingerprintSetupSubtitle2
        multiBiomentricHelpButtonTitle = Strings.Localizable.biometryMultipleTouchInfoTitle
        analyticsName = "touchid_setup"
    }

    private func storePin() {
        guard let pinCode = pinCode else { return assertionFailure("pinCode should be set") }
        pinStore
            .save(pinCode: pinCode)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    if self?.biometryAvailability == .biometryLocked {
                        self?.alert = .biometryLockedAlert
                    }
                    self?.setup()
                case .finished:
                    self?.listener?.onBiometrySetupFinished()
                }
            })
            .store(in: &disposeBag)
    }
}
