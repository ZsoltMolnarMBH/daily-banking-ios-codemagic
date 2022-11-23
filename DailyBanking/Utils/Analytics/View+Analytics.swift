//
//  View+Analytics.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 13..
//

import SwiftUI
import Resolver
import Firebase

protocol ViewAnalyticsInterface {
    func logButtonPress(contentType: String, componentLabel: String?)
    func logScreenView(_ screenName: String)
}

extension View {
    var analytics: ViewAnalyticsInterface { Resolver.resolve() }

    @ViewBuilder
    func analyticsScreenView(_ screenName: String) -> some View {
        self.onAppear {
            guard !screenName.isEmpty else { return }
            analytics.logScreenView(screenName)
        }
        .onChange(of: screenName) { newValue in
            guard !newValue.isEmpty else { return }
            analytics.logScreenView(newValue)
        }
    }
}

extension AppAnalytics: ViewAnalyticsInterface {
    func logScreenView(_ screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: "SwiftUI"
        ])
    }
}
