//
//  LAContext+Extensions.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 10..
//

import Combine
import LocalAuthentication

extension LAContext {
    enum BiometryAvailability {
        case notAvailable
        case available
        case permissionDenied
        case disabledOSLevel
        case biometryLocked
    }

    var localizedReason: String {
        if biometryType == .faceID {
            return Strings.Localizable.ownerevaluationReasonFaceIdIos
        } else {
            return Strings.Localizable.ownerevaluationReasonTouchIdIos
        }
    }

    static var new: LAContext {
        let authContext = LAContext()
        authContext.localizedFallbackTitle = ""
        authContext.localizedCancelTitle = Strings.Localizable.commonSkip
        var error: NSError?
        authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return authContext
    }

    var biometryAvailability: BiometryAvailability {
        guard biometryType != .none else { return .notAvailable }
        var error: NSError?
        if canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return .available
        } else {
            if let code = error?.code {
                switch Int32(code) {
                case kLAErrorPasscodeNotSet, kLAErrorBiometryNotEnrolled:
                    return .disabledOSLevel
                case kLAErrorBiometryNotAvailable:
                    return .permissionDenied
                case kLAErrorBiometryLockout:
                    return .biometryLocked
                default:
                    break
                }
            }
        }
        return .notAvailable
    }

    func evaluateOwner() -> AnyPublisher<Bool, Swift.Error> {
        Future { [localizedReason] promise in
            self.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: localizedReason) { isEvaluated, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(isEvaluated))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
