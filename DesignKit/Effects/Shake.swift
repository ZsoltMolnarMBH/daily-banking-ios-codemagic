//
//  Shake.swift
//  DesignKit
//
//  Created by Molnár Zsolt on 2021. 11. 10..
//

import SwiftUI

public struct Shake: GeometryEffect {
    public var amount: CGFloat
    public var shakesPerUnit: Int
    public var animatableData: CGFloat

    public init(amount: CGFloat = 10, shakesPerUnit: Int = 3, animatableData: CGFloat) {
        self.amount = amount
        self.shakesPerUnit = shakesPerUnit
        self.animatableData = animatableData
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
