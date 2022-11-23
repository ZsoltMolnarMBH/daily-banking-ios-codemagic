//
//  DesignHighlightRow.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 03. 25..
//

import SwiftUI

public struct DesignHighlightRow: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    public init() { }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed ? Color.background.primaryPressed : Color.background.primary
            )
    }
}
