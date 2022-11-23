//
//  ProgressStepViewVertical.swift
//  DesignKit
//
//  Created by Alexa Mark on 2021. 11. 30..
//

import SwiftUI

public struct ProgressStepViewVertical: View {
    let steps: [String]
    let currentStepNumber: Int // The first step number is 1.
    var maxSteps: Int {
        self.steps.count
    }

    public init(
        steps: [String],
        currentStepNumber: Int
    ) {
        self.steps = steps
        self.currentStepNumber = currentStepNumber
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .xxs) {
            ForEach(1...maxSteps, id: \.self) { step in
                StepViewVertical(
                    status: stepStatus(from: step),
                    isFirst: step == 1,
                    text: steps[step - 1]
                )
                .zIndex(Double(maxSteps - step))
            }
        }
    }

    func stepStatus(from step: Int) -> StepViewVertical.Status {
        if step < currentStepNumber {
            return .fulfilled
        } else if step == currentStepNumber {
            return .current
        } else {
            return .future
        }
    }
}

struct StepViewVertical: View {
    enum Status {
        case fulfilled, current, future
    }

    let status: Status
    let isFirst: Bool
    let text: String

    var body: some View {
        HStack(alignment: .bottom, spacing: .xl) {
            VStack(spacing: .xxs) {
                if !isFirst {
                    RoundedRectangle(cornerRadius: 2)
                        .fill()
                        .frame(width: 4, height: 40)
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
            Text(text)
                .textStyle(.body1)
                .foregroundColor(.text.secondary)
                .offset(x: 0, y: 5)
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

struct StepViewVerticalPreview: PreviewProvider {
    static var previews: some View {
        StepViewVertical(status: .current, isFirst: false, text: "Ez már megint egy text")
    }
}

struct ProgressStepViewVerticalPreview: PreviewProvider {
    static var previews: some View {
        ProgressStepViewVertical(
            steps: ["hallo", "mizujs", "Számlacsomag-választás", "Nyilatkozatok elfogadása"],
            currentStepNumber: 2
        )
    }
}
