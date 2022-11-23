//
//  Analytics.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 13..
//

import Firebase
import Resolver

class AppAnalytics {
    @Injected(container: .root) private var appConfig: AppConfig
    @Injected(container: .root) private var appInfo: AppInformation

    init() {
        Analytics.setUserProperty(Locale.current.languageCode, forName: "app_language")
        Analytics.setUserProperty(appInfo.buildNumber, forName: "build_number")
        #if DEBUG
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        #endif
        Analytics.setAnalyticsCollectionEnabled(appConfig.general.isAnalyticsCollectionEnabled)
    }

    func logButtonPress(contentType: String, componentLabel: String?) {
        var parameters: [String: Any] = [
            AnalyticsParameterContentType: contentType
        ]
        if let componentLabel = componentLabel {
            parameters["component_label"] = componentLabel
        }
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: parameters)
    }
}
