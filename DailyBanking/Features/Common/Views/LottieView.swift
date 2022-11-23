//
//  LottieView.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 12..
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    enum LoopMode: Equatable {
        case playOnce
        case loop
        case autoReverse
        case `repeat`(times: Float)
        case repeatBackwards(times: Float)
        case endFrameFreezed
    }

    enum Schedule {
        case instant
        case delayed(TimeInterval)
    }

    let animation: ThemeAwareAnimation
    let loopMode: LoopMode
    let schedule: Schedule

    class Coordinator {
        var currentScheme: ColorScheme?
        var alreadyPlayed = false
    }

    init(animation: ThemeAwareAnimation, loopMode: LoopMode = .playOnce, schedule: Schedule = .instant) {
        self.animation = animation
        self.loopMode = loopMode
        self.schedule = schedule
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> AnimationView {
        let animationView = AnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .init(from: loopMode)
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }

    func updateUIView(_ uiView: AnimationView, context: Context) {
        guard context.coordinator.currentScheme != context.environment.colorScheme else { return }
        if loopMode == .endFrameFreezed {
            context.coordinator.alreadyPlayed = true
        }

        let isLight = context.environment.colorScheme == .light
        context.coordinator.currentScheme = isLight ? .light : .dark
        uiView.animation = isLight ? animation.light : animation.dark

        if !context.coordinator.alreadyPlayed {
            switch schedule {
            case .instant:
                uiView.play()
            case .delayed(let timeInterval):
                DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak uiView] in
                    uiView?.play()
                }
            }
            if loopMode == .playOnce {
                context.coordinator.alreadyPlayed = true
            }
        } else if let endFrame = uiView.animation?.endFrame {
            uiView.play(fromFrame: endFrame, toFrame: endFrame)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

extension LottieLoopMode {
    init(from loopMode: LottieView.LoopMode) {
        switch loopMode {
        case .playOnce, .endFrameFreezed:
            self = .playOnce
        case .loop:
            self = .loop
        case .autoReverse:
            self = .autoReverse
        case .repeat(let times):
            self = .repeat(times)
        case .repeatBackwards(let times):
            self = .repeatBackwards(times)
        }
    }
}
