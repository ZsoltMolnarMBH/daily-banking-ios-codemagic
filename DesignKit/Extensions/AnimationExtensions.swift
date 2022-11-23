//
//  AnimationExtensions.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 11. 05..
//

import SwiftUI

public extension Animation {
    static let fast: Animation = {
        Animation.easeOut(duration: 0.2)
    }()
}
