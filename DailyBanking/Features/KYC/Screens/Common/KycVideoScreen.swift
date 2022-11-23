//
//  KycVideoScreen.swift
//  FaceKomPOC
//
//  Created by Szabó Zoltán on 2022. 04. 07..
//

import SwiftUI
import Combine
import DesignKit
import WebRTC

protocol KycVideoScreenViewModelProtocol: ObservableObject {
    var shape: CameraFinderView.Shape { get }
    var state: CameraVideoOverlayView.ValidationState { get }
    var text: String? { get }
    var progress: Float? { get }
    var animation: CameraFinderView.Animation? { get }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }

    func handle(_ event: KycVideoScreenInput)
}

enum KycVideoScreenInput {
    case onAppear(videoView: RTCVideoRenderer)
}

struct KycVideoScreen<ViewModel: KycVideoScreenViewModelProtocol>: View {
    let webRTCVideoView = WebRTCVideoView()

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            ZStack {
                webRTCVideoView

                CameraVideoOverlayView(
                    shape: viewModel.shape,
                    state: viewModel.state,
                    text: viewModel.text,
                    animation: viewModel.animation
                )
            }
            .ignoresSafeArea(.all)

            if let progress = viewModel.progress {
                VStack {
                    ProgressView(value: progress)
                        .progressViewStyle(
                            LinearProgressViewStyle(tint: .highlight.tertiary)
                        )
                        .animation(.default, value: progress)
                        .background(Rectangle().fill(Color.background.primaryDisabled))
                    Spacer()
                }
                .padding(.top, .xxs)
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.handle(.onAppear(videoView: webRTCVideoView.uiKitComponent.videoView))
        }
        .designAlert(viewModel.bottomAlert)
        .preferredColorScheme(.dark)
    }
}

private class MockViewModel: KycVideoScreenViewModelProtocol {
    var toast: AnyPublisher<String, Never> { Empty().eraseToAnyPublisher() }
    let shape: CameraFinderView.Shape = .capsule
    let state: CameraVideoOverlayView.ValidationState = .normal
    let text: String? = "This is the text"
    let progress: Float? = 0.3
    let animation: CameraFinderView.Animation? = .init(kind: .hint, asset: .faceTheCamera)
    var bottomAlert = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()

    func handle(_ event: KycVideoScreenInput) {}
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        KycVideoScreen(viewModel: MockViewModel())
            .previewDevice("iPhone 13 mini")
    }
}
