//
//  CameraVideoOverlayView.swift
//  FaceKomPOC
//
//  Created by ALi on 2022. 03. 21..
//

import DesignKit
import SwiftUI

struct CameraVideoOverlayView: View {
    @Environment(\.keyWindowSafeAreaInsets) private var safeArea
    @Environment(\.isSensitiveContent) private var isSensitiveContent

    enum ValidationState: Equatable {
        case normal, loading, warning, error, success
    }

    struct Action {
        let title: String
        let block: () -> Void
    }

    let shape: CameraFinderView.Shape
    let state: ValidationState
    let text: String?
    let animation: CameraFinderView.Animation?

    var body: some View {
        ZStack {
            CameraFinderView(
                shape: shape,
                state: finderState,
                animation: animation,
                obscureContent: hideSensitiveContent
            )
            .animation(.default, value: state)

            VStack(spacing: 0) {
                Color.clear

                Color.clear
                    .aspectRatio(
                        shape.aspectRatio,
                        contentMode: .fit
                    )
                    .padding(.horizontal, shape.padding)
                    .layoutPriority(1)

                Color.clear
                    .overlay {
                        VStack(spacing: 0) {
                            if let text = visibleText {
                                HStack {
                                    Spacer()
                                    Text(text)
                                        .textStyle(.headings4)
                                        .foregroundColor(textColor)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, .xxxl)
                                        .padding(.top, textTopPadding)
                                    Spacer()
                                }
                                .animation(.default, value: isHintMode)
                                .animation(.default, value: text)
                                .transition(.opacity)
                                .id(text)
                            }
                            if state == .loading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.3)
                                    .padding(.top, .l)
                            }
                            Spacer()
                        }
                    }
            }
        }
        .onChange(of: state) { newValue in
            let feedback = UINotificationFeedbackGenerator()
            switch newValue {
            case .error:
                feedback.notificationOccurred(.error)
            case .success:
                feedback.notificationOccurred(.success)
            default: break
            }
        }
        .onChange(of: text) { _ in
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
        }
        .ignoresSafeArea(edges: .all)
    }

    private var isHintMode: Bool {
        if let animation = animation, animation.kind == .hint {
            return true
        }
        return false
    }

    private var textTopPadding: CGFloat {
        guard !isHintMode else { return .m }
        switch state {
        case .loading:
            return .l
        default:
            return shape == .rectangle ? .m : 62
        }
    }

    private var finderState: CameraFinderView.FinderState {
        switch state {
        case .normal, .loading:
            return .normal
        case .warning:
            return .warning
        case .error:
            return .error
        case .success:
            return .success
        }
    }

    private var textColor: SwiftUI.Color {
        switch state {
        case .warning:
            return .warning.highlight
        case .error:
            return .error.highlight
        default:
            return .text.primary
        }
    }

    private var visibleText: String? {
        switch state {
        case .loading:
            return Strings.Localizable.commonPleaseWait
        case .success:
            return nil
        default:
            return text
        }
    }

    private var hideSensitiveContent: Bool {
        if !isHintMode, shape == .rectangle, isSensitiveContent {
            return true
        }
        return false
    }
}

struct CameraVideoOverlayPreview: PreviewProvider {
    static var previews: some View {
        CameraVideoOverlayView(
            shape: .capsule,
            state: .normal,
            text: "This is the text, but whats happening if it goes to multiline",
            animation: .init(kind: .task, asset: .faceTheCamera)
        )
        .preferredColorScheme(.dark)
    }
}
