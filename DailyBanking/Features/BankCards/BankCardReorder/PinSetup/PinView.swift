//
//  PinView.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 05. 17..
//

import SwiftUI

enum PinCodeState: Equatable {
    case editing
    case error
    case success
    case disabled
}

struct PinView: View {

    let cornerRadius = 10.0
    let width = 50.0
    let height = 72.0

    var hasValue: Bool = false
    
    var editing: Bool = false

    var state: PinCodeState = .editing

    var borderColor: Color {

        switch state {
        case .error:
            return Color.error.primary.foreground
        case .success:
            return Color.success.secondary.foreground
        default:
            return hasValue || editing ? Color.highlight.primary.background : Color.element.tertiary
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .foregroundColor(Color.element.primary.foreground)
                .foregroundColor(Color.element.primary.foreground)
                .frame(width: self.width, height: self.height)
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .stroke(lineWidth: 2)
                .foregroundColor(borderColor)
                .frame(width: self.width, height: self.height)
            if self.hasValue {
                Text("•")
                    .textStyle(.headings1)
                    .foregroundColor(Color.text.tertiary)
            }
        }
        .animation(.default, value: editing)
    }
}
