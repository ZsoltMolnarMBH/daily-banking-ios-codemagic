//
//  CameraPreviewProvider.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 22..
//

import Combine
import Foundation
import AVFoundation
import VideoToolbox

protocol CameraPreviewProvider {
    var currentFrame: AnyPublisher<CGImage?, Never> { get }
    func configure(on position: AVCaptureDevice.Position)
    func start()
    func stop()
}

class DefaultCameraPreviewProvider: NSObject, CameraPreviewProvider {
    var currentFrame: AnyPublisher<CGImage?, Never> {
        _currentFrame.eraseToAnyPublisher()
    }
    private let _currentFrame = PassthroughSubject<CGImage?, Never>()
    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()

    let videoOutputQueue = DispatchQueue(
        label: "cameraPreviewProvider.outputqueue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)

    func configure(on position: AVCaptureDevice.Position) {

        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: position
        ) else { return }

        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(cameraInput),
              session.canAddOutput(videoOutput) else { return }

        session.beginConfiguration()
        session.addInput(cameraInput)
        session.addOutput(videoOutput)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)

        session.commitConfiguration()
    }

    func start() {
        DispatchQueue.global(qos: .userInitiated).async { self.session.startRunning() }
    }

    func stop() {
        session.stopRunning()
    }
}

extension DefaultCameraPreviewProvider: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                var image: CGImage?
                VTCreateCGImageFromCVPixelBuffer(
                    buffer,
                    options: nil,
                    imageOut: &image
                )
                self._currentFrame.send(image)
            }
        }
    }
}
