//
//  CountDownView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 11. 04..
//

import SwiftUI

public struct CountDownView: View {
    @Environment(\.isEnabled) var isEnabled
    private var startedAt: Date
    private var countDownTime: TimeInterval

    public init(
        countDownTime: TimeInterval,
        startedAt: Date = Date()
    ) {
        self.countDownTime = countDownTime
        self.startedAt = startedAt
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(
                    lineWidth: 12.0,
                    lineCap: .round,
                    lineJoin: .round
                ))
                .foregroundColor(isEnabled ? .background.primaryPressed : .text.disabled)

            TimelineView(.animation) { timeline in
                ZStack {
                    Circle()
                        .trim(from: calculateProgress(from: timeline.date), to: 1)
                        .stroke(style: StrokeStyle(
                            lineWidth: 12.0,
                            lineCap: .round,
                            lineJoin: .round
                        ))
                        .rotationEffect(Angle(degrees: 270))
                        .foregroundColor(isEnabled ? .highlight.tertiary : .text.disabled)
                }
            }
        }
        .frame(width: 156, height: 156)
        .padding(.s)
    }

    private func calculateProgress(from date: Date) -> CGFloat {
        let remaining = max(0, countDownTime - date.timeIntervalSince(startedAt))
        let progress = CGFloat(remaining / countDownTime)
        return isEnabled ? 1 - progress : 1
    }
}

struct CountDownViewView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CountDownView(countDownTime: 12)
        }
        .preferredColorScheme(.light)
    }
}

struct CountDownViewDark_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CountDownView(countDownTime: 12)
        }
        .preferredColorScheme(.dark)
    }
}
