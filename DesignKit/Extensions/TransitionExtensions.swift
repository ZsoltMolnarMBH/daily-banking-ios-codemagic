//
//  TransitionExtensions.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 03. 30..
//

import SwiftUI

public extension AnyTransition {
    static var slideLeft: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}
