//
//  LinearProgressView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 03. 25..
//

import SwiftUI

public struct LinearProgressView: View {

    let steps: Int
    @Binding var currentStep: Int
    @State private var progress: Float = 0.0

    public init(steps: Int, currentStep: Binding<Int>) {
        self.steps = steps
        self._currentStep = currentStep
    }

    public var body: some View {
        HStack(spacing: 0) {
            ProgressView(value: progress)
                .background(Color.background.primaryDisabled)
                .progressViewStyle(LinearProgressViewStyle(tint: .highlight.tertiary))
                .animation(.easeInOut(duration: 0.3), value: progress)
            Text("\(currentStep + 1)/\(steps)")
                .padding(.leading, .m)
                .textStyle(.body3)
                .foregroundColor(.text.tertiary)
        }
        .onChange(of: currentStep) { _ in calculateProgress() }
        .onAppear { calculateProgress() }
    }

    private func calculateProgress() {
        if currentStep + 1 >= steps || steps <= 0 {
            progress = 1.0
        } else if currentStep + 1 <= 0 {
            progress = 0.0
        } else {
            progress = Float(currentStep + 1) / Float(steps)
        }
    }
}

struct LinearProgressViewPreviews: PreviewProvider {
    static var previews: some View {
        LinearProgressView.init(steps: 5, currentStep: .constant(4))
            .padding(.horizontal, .m)
    }
}
