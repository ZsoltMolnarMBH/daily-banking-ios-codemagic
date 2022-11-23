//
//  KycPhotoScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 21..
//

import SwiftUI
import Combine
import DesignKit
import WebRTC

protocol KycPhotoScreenViewModelProtocol: ObservableObject {
    var frame: CGImage? { get }

    var state: CameraPhotoOverlayView.OverlayState { get }
    var shape: CameraFinderView.Shape { get }
    var mode: CameraPhotoOverlayView.Mode { get }
    var previewOrientation: Image.Orientation { get }

    var snapshotImage: UIImage? { get }
    func handle(_ event: KycPhotoScreenInput)
}

extension KycPhotoScreenViewModelProtocol {
    var previewOrientation: Image.Orientation { .up }
}

enum KycPhotoScreenInput {
    case takePhoto
}

struct KycPhotoScreen<ViewModel: KycPhotoScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if let frame = viewModel.frame {
                GeometryReader { geometry in
                    Image(
                        frame,
                        scale: 1.0,
                        orientation: viewModel.previewOrientation,
                        label: Text("Preview")
                    )
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .center)
                    .clipped()
                }
            }

            if let image = viewModel.snapshotImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .layoutPriority(-1)
            }

            CameraPhotoOverlayView(
                state: viewModel.state,
                shape: viewModel.shape,
                mode: viewModel.mode,
                onShutter: { viewModel.handle(.takePhoto) }
            )
        }
        .ignoresSafeArea(.all)
        .preferredColorScheme(.dark)
    }
}

private class MockViewModel: KycPhotoScreenViewModelProtocol {
    var frame: CGImage?
    var state: CameraPhotoOverlayView.OverlayState = .error(Strings.Localizable.kycPhotoErrorFaceMissing)
    var shape: CameraFinderView.Shape = .capsule
    var mode: CameraPhotoOverlayView.Mode = .capture(info: "Fotózz")
    var snapshotImage: UIImage?

    func handle(_ event: KycPhotoScreenInput) {}
}

struct PhotoView2_Previews: PreviewProvider {
    static var previews: some View {
        KycPhotoScreen(viewModel: MockViewModel())
            .previewDevice("iPhone 7")
    }
}
