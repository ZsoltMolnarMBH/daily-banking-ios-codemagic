//
//  BiometryToggleUnavailableScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 14..
//

import Combine
import Foundation
import LocalAuthentication
import Resolver

protocol BiometryUnavailableScreenListener: AnyObject {
    func helpRequested()
    func settingsRequested()
    func biometryBecameAvailable()
}

class BiometryUnavailableScreenViewModel: BiometryUnavailableScreenViewModelProtocol {
    weak var listener: BiometryUnavailableScreenListener?
    private var authContext = LAContext.new

    var imageName: ImageName {
        authContext.biometryType == .faceID ? .faceid : .touchId
    }
    var title: String {
        if authContext.biometryType == .faceID {
            return Strings.Localizable.biometrySetupDisabledFaceidInfoTitle
        } else {
            return Strings.Localizable.biometrySetupDisabledTouchidInfoTitle
        }
    }

    private var disposeBag = Set<AnyCancellable>()

    init() {
        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.willEnterForegroundNotification
        ).sink { [listener, authContext] _ in
            if authContext.biometryAvailability == .available {
                listener?.biometryBecameAvailable()
            }
        }
        .store(in: &disposeBag)
    }

    func handle(_ event: BiometryUnavailableScreenInput) {
        switch event {
        case .help:
            listener?.helpRequested()
        case .openSettings:
            listener?.settingsRequested()
        }
    }
}
