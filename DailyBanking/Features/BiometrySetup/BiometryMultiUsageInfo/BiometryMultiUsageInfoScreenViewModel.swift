//
//  BiometryMultiUsageInfoScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 11..
//

import SwiftUI
import Resolver
import LocalAuthentication

class BiometryMultiUsageInfoScreenViewModel: BiometryMultiUsageInfoScreenViewModelProtocol {
    var onClose: (() -> Void)?

    @Published var biometryImage: ImageName = .faceid
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var subtitle: String = ""
    @Published var analyticsScreenName: String = ""

    init() {
        if LAContext.new.biometryType == .faceID {
            setupForFaceID()
        } else {
            setupForTouchID()
        }
    }

    func handle(event: BiometryMultiUsageInfoScreenInput) {
        switch event {
        case .close:
            onClose?()
        }
    }

    private func setupForFaceID() {
        biometryImage = .faceid
        title = Strings.Localizable.biometryMultipleFaceidInfoTitle
        message = Strings.Localizable.biometryMultipleFaceidInfoSubtitleIos
        subtitle = Strings.Localizable.biometryMultipleFaceidInfoSubtitle2Ios
        analyticsScreenName = "biometric_faceid_info"
    }

    private func setupForTouchID() {
        biometryImage = .touchId
        title = Strings.Localizable.biometryMultipleTouchInfoTitle
        message = Strings.Localizable.biometryMultipleTouchInfoSubtitleIos
        subtitle = Strings.Localizable.biometryMultipleTouchInfoSubtitle2Ios
        analyticsScreenName = "biometric_touchid_info"
    }
}
