//
//  LottieAnimations.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 16..
//

import Foundation
import Lottie

struct ThemeAwareAnimation {
    let light: Lottie.Animation
    let dark: Lottie.Animation

    init(light: Lottie.Animation, dark: Lottie.Animation) {
        self.light = light
        self.dark = dark
    }

    init(_ animation: Lottie.Animation) {
        self.light = animation
        self.dark = animation
    }
}

extension ThemeAwareAnimation {
    static let faceUp = ThemeAwareAnimation(.faceUp)
    static let faceDown = ThemeAwareAnimation(.faceDown)
    static let faceRight = ThemeAwareAnimation(.faceRight)
    static let faceLeft = ThemeAwareAnimation(.faceLeft)
    static let faceTheCamera = ThemeAwareAnimation(.faceFace)
    static let addressCard = ThemeAwareAnimation(.addressCard)
    static let idFront = ThemeAwareAnimation(.idCardFront)
    static let idBack = ThemeAwareAnimation(.idCardBack)
    static let idTilt = ThemeAwareAnimation(.idTilt)
    static let idAndAddress = ThemeAwareAnimation(.idAndAddressCard)
    static let success = ThemeAwareAnimation(light: .successLight, dark: .successDark)
    static let alert = ThemeAwareAnimation(light: .alertLight, dark: .alertDark)
    static let warning = ThemeAwareAnimation(light: .warningLight, dark: .warningDark)
    static let nfc = ThemeAwareAnimation(light: .nfcLight, dark: .nfcDark)
}
