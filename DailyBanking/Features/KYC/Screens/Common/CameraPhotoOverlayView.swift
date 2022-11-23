//
//  CameraPhotoOverlayView.swift
//  FaceKomPOC
//
//  Created by ALi on 2022. 03. 21..
//

import DesignKit
import Resolver
import SwiftUI

struct CameraPhotoOverlayView: View {
    @Environment(\.keyWindowSafeAreaInsets) private var safeArea
    @Environment(\.isSensitiveContent) private var isSensitiveContent

    enum OverlayState: Equatable {
        case normal, loading, error(String), success
    }

    enum Mode: Equatable {
        case instructions(text: String, animation: CameraFinderView.Animation)
        case capture(info: String)

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.capture, .capture), (.instructions, .instructions):
                return true
            default:
                return false
            }
        }
    }

    let state: OverlayState
    let shape: CameraFinderView.Shape
    let mode: Mode
    let onShutter: (() -> Void)?

    var body: some View {
        ZStack {
            CameraFinderView(
                shape: shape,
                state: finderState,
                animation: animation,
                obscureContent: hideSensitiveContent
            )

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
                        VStack {
                            if let text = text {
                                Text(text)
                                    .textStyle(.headings4)
                                    .foregroundColor(textColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, .xxxl)
                                    .padding(.top, .m)
                            }
                            Spacer()
                        }
                    }
            }

            VStack(alignment: .center, spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    switch mode {
                    case .capture:
                        HStack {
                            Spacer()
                            if isShutterButtonVisible {
                                PhotoShutterButton(isLoading: state == .loading) {
                                    onShutter?()
                                }
                                .padding(.bottom, safeArea.bottom)
                            }
                            Spacer()
                        }
                    case .instructions:
                        EmptyView()
                    }
                }
                .frame(height: 72)
                .padding(.bottom, .m)
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
        .animation(.default, value: mode)
        .animation(.default, value: state)
        .ignoresSafeArea(edges: .all)
        .preferredColorScheme(.dark)
    }

    private var isShutterButtonVisible: Bool {
        switch state {
        case .normal, .loading:
            return true
        case .error, .success:
            return false
        }
    }

    private var finderState: CameraFinderView.FinderState {
        switch state {
        case .normal, .loading:
            return .normal
        case .error:
            return .error
        case .success:
            return .success
        }
    }

    private var animation: CameraFinderView.Animation? {
        switch mode {
        case .instructions(_, let animation):
            return animation
        case .capture:
            return nil
        }
    }

    private var text: String? {
        switch state {
        case .error(let errorText):
            return errorText
        case .success, .loading:
            return nil
        default:
            switch mode {
            case .instructions(let text, _):
                return text
            case .capture(let info):
                return info
            }
        }
    }

    private var textColor: Color {
        switch state {
        case .error:
            return .error.highlight
        default:
            return .text.primary
        }
    }

    private var hideSensitiveContent: Bool {
        if case .capture = mode, shape == .rectangle, isSensitiveContent {
            return true
        }
        return false
    }
}

struct CameraOverlayPreview: PreviewProvider {
    static var previews: some View {
        CameraPhotoOverlayView(
            state: .error("This is the Error"),
            shape: .capsule,
            mode: .capture(info: "CaptureInfo"),
//            mode: .instructions(
//                text: "Text",
//                animation: .faceTheCamera
//            ),
            onShutter: { }
        )
        .environment(\.isSensitiveContent, true)

        CameraPhotoOverlayView(
            state: .normal,
            shape: .rectangle,
            mode: .capture(info: "CaptureInfo"),
            onShutter: { }
        ).environment(\.isSensitiveContent, true)
    }
}
