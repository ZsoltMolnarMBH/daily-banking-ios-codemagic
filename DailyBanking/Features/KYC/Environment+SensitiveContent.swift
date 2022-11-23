//
//  Environment+SensitiveContent.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 10..
//

import SwiftUI
import Resolver

private struct SensitiveContentKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    var isSensitiveContent: Bool {
        get { self[SensitiveContentKey.self] }
        set { self[SensitiveContentKey.self] = newValue }
    }
}
