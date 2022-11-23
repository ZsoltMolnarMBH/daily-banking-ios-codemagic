//
//  Result+PermissionDenied.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 06..
//

import DesignKit
import Foundation

extension ResultModel {
    static func cameraPermissionDeniedKyc(action: @escaping () -> Void) -> ResultModel {
        .init(
            icon: .image(.warningSemantic),
            title: Strings.Localizable.kycCameraPermissionDeniedTitle,
            subtitle: Strings.Localizable.kycCameraPermissionDeniedDescriptionSettings,
            primaryAction: .init(
                title: Strings.Localizable.kycCameraPermissionDeniedActionSettings,
                action: action
            ),
            analyticsScreenView: "oao_ekyc_error_approve_recording"
        )
    }
}
