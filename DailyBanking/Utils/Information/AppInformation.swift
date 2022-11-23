//
//  AppInformation.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 06..
//

import Foundation
import UIKit

struct AppInformation {
    let version: String
    let buildNumber: String
    let buildConfiguration: String
}

class AppInformationProvider {
    let information: AppInformation = {
        .init(version: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "",
              buildNumber: (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "",
              buildConfiguration: (Bundle.main.infoDictionary?["BUILD_CONFIGURATION_NAME"] as? String) ?? "unknown")
    }()
}

extension AppInformation {
    /// Detailed information about the current version.
    /// Format: versionNumber (buildNumber) - buildConfigurattion
    /// Example: 1.2.3 (456) - Debug
    var detailedVersion: String {
        return "\(version) (\(buildNumber)) - \(buildConfiguration)"
    }
}
