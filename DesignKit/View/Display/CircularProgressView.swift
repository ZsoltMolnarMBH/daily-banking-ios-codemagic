//
//  CircularProgressView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 28..
//

import SwiftUI

public struct CircularProgressView: View {
    var progress: Float

    public init(
        progress: Float
    ) {
        self.progress = progress
    }

    public var body: some View {
        Circle()
            .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
            .stroke(style: StrokeStyle(
                lineWidth: 12.0,
                lineCap: .round,
                lineJoin: .round
            ))
            .rotationEffect(Angle(degrees: 270.0))
            .frame(width: 124, height: 124)
            .padding(.s)
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircularProgressView(progress: 1)
                .foregroundColor(.highlight.tertiary)
        }
        .preferredColorScheme(.light)
    }
}

struct CircularProgressViewDark_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircularProgressView(progress: 0.8)
                .foregroundColor(.highlight.tertiary)
        }
        .preferredColorScheme(.dark)
    }
}
