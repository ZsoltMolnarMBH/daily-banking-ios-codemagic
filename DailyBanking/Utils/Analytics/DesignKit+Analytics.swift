//
//  DesignKit+Analytics.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 13..
//

import DesignKit

extension AppAnalytics: DesignKit.AnalyticsInterface {
    func log(buttonPress: DesignButton.AnalyticsData) {
        var contentType = buttonPress.style.rawValue + " button"
        if let override = buttonPress.contentTypeOverride {
            contentType = override
        }
        let componentLabel = buttonPress.title
        logButtonPress(contentType: contentType, componentLabel: componentLabel)
    }

    func log(buttonPress: CardButton.AnalyticsData) {
        var contentType = "action card"
        if let override = buttonPress.contentTypeOverride {
            contentType = override
        }
        let componentLabel = buttonPress.title
        logButtonPress(contentType: contentType, componentLabel: componentLabel)
    }

    func log(buttonPress: VerticalButton.AnalyticsData) {
        var contentType = "action button"
        if let override = buttonPress.contentTypeOverride {
            contentType = override
        }
        let componentLabel = buttonPress.text
        logButtonPress(contentType: contentType, componentLabel: componentLabel)
    }

    func log(buttonPress: CheckBoxRow.AnalyticsData) {
        var contentType = "checkbox \(buttonPress.isChecked ? "enabled" : "disabled")"
        if let override = buttonPress.contentTypeOverride {
            contentType = override
        }
        let componentLabel = buttonPress.text
        logButtonPress(contentType: contentType, componentLabel: componentLabel)
    }

    func log(buttonPress: AlertRadioButtonListAnalyticsData) {
        var contentType = "pop-up radio button"
        if let override = buttonPress.contentTypeOverride {
            contentType = override
        }
        let componentLabel = buttonPress.selectedLabel
        logButtonPress(contentType: contentType, componentLabel: componentLabel)
    }
}
