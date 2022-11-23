//
//  DesignKitModule.swift
//  DesignKit
//
//  Created by Molnár Zsolt on 2021. 12. 13..
//

import Foundation

public class DesignKitModule {
    static var analytics: AnalyticsInterface?

    public static func configue(analytics: AnalyticsInterface?) {
        Self.analytics = analytics
    }
}
