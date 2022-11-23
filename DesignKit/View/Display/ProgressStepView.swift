//
//  ProgressStepView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 11. 18..
//

import SwiftUI

public struct ProgressStepView: View {

    let maxSteps: Int
    let currentStep: Int

    public init(
        maxSteps: Int,
        currentStep: Int
    ) {
        self.maxSteps = maxSteps
        self.currentStep = currentStep
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(1...maxSteps, id: \.self) { step in
                StepView(
                    status: stepStatus(from: step),
                    isFirst: step == 1
                )
                .zIndex(Double(maxSteps - step))
            }
        }
    }

    func stepStatus(from step: Int) -> StepView.Status {
        if step < currentStep {
            return .fulfilled
        } else if step == currentStep {
            return .current
        } else {
            return .future
        }
    }
}

struct StepView: View {
    enum Status {
        case fulfilled, current, future
    }

    let status: Status
    let isFirst: Bool

    var body: some View {
        HStack(spacing: 0) {
            if !isFirst {
                RoundedRectangle(cornerRadius: 2)
                    .fill()
                    .frame(width: 40, height: 4)
                    .foregroundColor(lineColor)
            }
            Circle()
                .fill()
                .frame(width: 8, height: 8)
                .foregroundColor(dotColor)
                .padding(.horizontal, .xxs)
                .overlay {
                    if status == .current {
                        Circle()
                            .stroke(style: StrokeStyle(
                                lineWidth: 6.0,
                                lineCap: .round,
                                lineJoin: .round
                            ))
                            .foregroundColor(.highlight.tertiary)
                            .frame(width: 14, height: 14)
                    } else {
                        EmptyView()
                    }
                }
        }
    }

    var lineColor: Color {
        switch status {
        case .fulfilled, .current:
            return .highlight.tertiary
        case .future:
            return .background.primaryDisabled
        }
    }

    var dotColor: Color {
        switch status {
        case .fulfilled:
            return .highlight.tertiary
        case .future, .current:
            return .background.primaryDisabled
        }
    }
}

struct StepPreview: PreviewProvider {
    static var previews: some View {
        StepView(status: .current, isFirst: false)
    }
}

struct ProgressStepViewPreview: PreviewProvider {
    static var previews: some View {
        ProgressStepView(
            maxSteps: 4,
            currentStep: 2
        )
    }
}
