//
//  AnalyticsInterface.swift
//  DesignKit
//
//  Created by Molnár Zsolt on 2021. 12. 13..
//

import SwiftUI

public protocol AnalyticsInterface {
    func log(buttonPress: CardButton.AnalyticsData)
    func log(buttonPress: DesignButton.AnalyticsData)
    func log(buttonPress: VerticalButton.AnalyticsData)
    func log(buttonPress: CheckBoxRow.AnalyticsData)
    func log(buttonPress: AlertRadioButtonListAnalyticsData)
}

public protocol OverrideableContentType {
    var contentTypeOverride: String? { get set }
}

public extension View where Self: OverrideableContentType {
    func analyticsOverride(contentType: String) -> some View {
        var view = self
        view.contentTypeOverride = contentType
        return view
    }
}
