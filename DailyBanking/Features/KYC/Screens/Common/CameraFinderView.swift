//
//  CameraFinderView.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 30..
//

import SwiftUI
import DesignKit

private class Worker: ObservableObject {
    var work: DispatchWorkItem?
}

struct CameraFinderView: View {
    @Environment(\.keyWindowSafeAreaInsets) private var safeArea
    @StateObject private var worker = Worker()
    @State private var taskPosition: Position = .top
    @State private var taskBackground = false
    @Namespace var taskAnimation

    private enum Position: Equatable {
        case top, bottom
    }

    enum Shape {
        case rectangle, capsule

        var aspectRatio: Double {
            switch self {
            case .rectangle:
                return 343/223
            case .capsule:
                return 227/360
            }
        }

        var padding: CGFloat {
            switch self {
            case .rectangle:
                return .m
            case .capsule:
                // We need a bit larger padding in case of devices with 9:16 screen
                if (UIScreen.main.bounds.height / UIScreen.main.bounds.height) < 1.8 {
                    return 88
                }
                return 72
            }
        }
    }

    enum FinderState {
        case normal, error, warning, success

        var animation: ThemeAwareAnimation? {
            switch self {
            case .normal:
                return nil
            case .warning:
                return .warning
            case .error:
                return .alert
            case .success:
                return .success
            }
        }
    }

    struct Animation: Equatable {
        enum Kind {
            case hint, task
        }
        let kind: Kind
        let asset: ThemeAwareAnimation
        let id: UUID

        init(kind: Kind, asset: ThemeAwareAnimation) {
            self.kind = kind
            self.asset = asset
            self.id = UUID()
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    let shape: Shape
    let state: FinderState
    let animation: Animation?
    let obscureContent: Bool

    init(
        shape: Shape,
        state: FinderState,
        animation: Animation? = nil,
        obscureContent: Bool = false
    ) {
        self.shape = shape
        self.state = state
        self.animation = animation
        self.obscureContent = obscureContent
    }

    var body: some View {
        ZStack {
            if let animation = animation, animation.kind == .hint, state == .normal {
                ZStack {
                    grayGradient
                    LottieView(animation: animation.asset, loopMode: .playOnce, schedule: .delayed(0.5))
                        .aspectRatio(shape.aspectRatio, contentMode: .fit)
                        .padding(shape.padding + helperPadding)
                }
            } else {
                EmptyView()
            }

            overlay
                .reverseMask { makeView() }

            makeView(stroke: true)
                .if(obscureContent) { view in
                    view.overlay {
                        VStack {
                            ForEach(0..<8) { _ in
                                HStack {
                                    ForEach(0..<8) { _ in
                                        Color.clear.background(.ultraThinMaterial)
                                            .cornerRadius(24)
                                    }
                                }
                            }
                        }
                        .if(shape == .rectangle) { $0.clipShape(RoundedRectangle(cornerRadius: 25)) }
                        .if(shape == .capsule) { $0.clipShape(Capsule()) }
                        .padding(shape.padding)
                    }
                }
            VStack(spacing: 0) {
                Color.clear
                Color.clear
                    .aspectRatio(
                        shape.aspectRatio,
                        contentMode: .fit
                    )
                    .padding(.horizontal, shape.padding)
                    .layoutPriority(1)
                    .overlay {
                        switch state {
                        case .normal, .warning:
                            ZStack {
                                stateAnimation()
                                if let animation = animation, animation.kind == .task {
                                    taskAnimation(animation.asset, id: animation.id)
                                }
                            }
                        case .success, .error:
                            stateAnimation()
                        }
                    }

                Color.clear
            }

            topGradient
        }
        .onChange(of: animation) { _ in
            worker.work?.cancel()
            taskPosition = .top
            taskBackground = false
        }
        .animation(.default, value: animation)
        .ignoresSafeArea(.all)
    }

    @ViewBuilder
    var overlay: some View {
        if let animation = animation, animation.kind == .hint {
            DesignKit.Colors.grey1000
                .opacity(0.6)
        } else {
            Color.clear
                .background(Material.ultraThin)
        }
    }

    var grayGradient: some View {
        Color.clear
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        DesignKit.Colors.grey700,
                        DesignKit.Colors.grey1000
                    ]),
                    startPoint: .top, endPoint: .bottom
                )
            )
    }

    var topGradient: some View {
        VStack {
            Rectangle().fill(
                LinearGradient(
                    colors: [
                        DesignKit.Colors.grey1000.opacity(0.6),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: safeArea.top + 100)
            Spacer()
        }
    }

    func makeView(stroke: Bool = false) -> some View {
        shape.view(stroke: stroke ? strokeColor : nil)
            .aspectRatio(shape.aspectRatio, contentMode: .fit)
            .padding(shape.padding)
    }

    @ViewBuilder
    func stateAnimation() -> some View {
        if let animation = state.animation {
            LottieView(animation: animation, loopMode: .playOnce)
                .frame(width: 72, height: 72)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func taskAnimation(_ animation: ThemeAwareAnimation, id: UUID) -> some View {
        VStack(spacing: 0) {
            switch taskPosition {
            case .top:
                LottieView(animation: animation, loopMode: .playOnce)
                    .matchedGeometryEffect(id: "task", in: taskAnimation)
                    .aspectRatio(shape.aspectRatio, contentMode: .fit)
                    .padding(helperPadding)
                    .onAppear {
                        let work = DispatchWorkItem(block: {
                            withAnimation { taskPosition = .bottom }
                        })
                        worker.work?.cancel()
                        worker.work = work
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: work)
                    }
                    .id(id)
            case .bottom:
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.background.secondary)
                        .opacity(taskBackground ? 1 : 0)

                    LottieView(animation: animation, loopMode: .endFrameFreezed)
                        .matchedGeometryEffect(id: "task", in: taskAnimation)
                        .frame(width: 72, height: 72)
                        .onAppear { withAnimation { taskBackground = true } }
                        .id(id)
                }
                .frame(width: 88, height: 88)
                .offset(x: 0, y: 44)
            }
        }
    }

    private var strokeColor: Color {
        switch state {
        case .normal:
            return .background.secondary
        case .success:
            return .success.highlight
        case .warning:
            return .warning.highlight
        case .error:
            return .error.highlight
        }
    }

    private var helperPadding: CGFloat {
        switch shape {
        case .rectangle:
            return .m
        case .capsule:
            return .xs
        }
    }
}

private extension CameraFinderView.Shape {
    @ViewBuilder
    func view(stroke: Color? = nil) -> some View {
        switch self {
        case .rectangle:
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .if(stroke != nil) { view in
                    view.stroke(stroke!, lineWidth: 2.0)
                }
        case .capsule:
            Capsule()
                .if(stroke != nil) { view in
                    view.stroke(stroke!, lineWidth: 2.0)
                }
        }
    }
}

struct CameraFinderPreviews: PreviewProvider {
    static var previews: some View {
        CameraFinderView(
            shape: .rectangle,
            state: .normal,
            animation: .init(kind: .hint, asset: .idAndAddress),
            obscureContent: false
        )
        .preferredColorScheme(.dark)
    }
}
