//
//  BasePhotoScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 18..
//

import Foundation
import Combine
import Resolver
import SwiftUI
import AVFoundation

class BasePhotoScreenViewModel: ScreenViewModel<KycPageScreenEvent>, KycPhotoScreenViewModelProtocol {
    @Injected var previewProvider: CameraPreviewProvider
    @Injected var nextStep: ReadOnly<FaceKom.Step>
    @Injected var action: FaceKomAction
    @Injected var config: KycConfig

    var capturePosition: AVCaptureDevice.Position { .back }
    var previewOrientation: Image.Orientation = .up
    @Published var frame: CGImage?
    @Published var snapshotImage: UIImage?
    @Published var state: CameraPhotoOverlayView.OverlayState = .normal
    @Published var shape: CameraFinderView.Shape = .capsule
    @Published var mode: CameraPhotoOverlayView.Mode = .capture(info: "")

    let uploadImage = PassthroughSubject<UIImage, Never>()
    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        nextStep.publisher
            .dropFirst()
            .map { [unowned self] nextStep -> Bool in
                self.shouldFinish(when: nextStep)
            }
            .delay(for: 2, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isFinish in
                guard isFinish else { return }
                self?.disposeBag.removeAll()
                self?.previewProvider.stop()
                self?.events.send(.proceed)
            })
            .store(in: &disposeBag)

        uploadImage
            .map { [action] image -> AnyPublisher<Never, Error> in
                return action.upload(image: image)
                    .handleEvents(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.display(error: error)
                            self?.snapshotImage = nil
                        case .finished:
                            self?.state = .success
                        }
                    })
                    .catch { _ in Empty().setFailureType(to: Error.self).eraseToAnyPublisher() }
                    .delay(for: .seconds(3), scheduler: DispatchQueue.main)
                    .handleEvents(receiveCompletion: { [weak self] _ in
                        self?.state = .normal
                    })
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink(receiveCompletion: { _ in })
            .store(in: &disposeBag)

        Just(())
            .delay(for: 3, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.onNext()
            })
            .store(in: &disposeBag)

        previewProvider.currentFrame.assign(to: &$frame)
        previewProvider.configure(on: capturePosition)
        previewProvider.start()
    }

    func shouldFinish(when nextStep: FaceKom.Step) -> Bool {
        fatalError("must override!")
    }

    func display(error: FaceKomActionPhotoUploadError) {
        state = .error(Strings.Localizable.kycPhotoError)
    }

    func handle(_ event: KycPhotoScreenInput) {
        switch event {
        case .takePhoto:
            guard let frame = frame, state != .loading else { return }
            state = .loading
            uploadImage.send(prepare(frame: frame))
        }
    }

    func onNext() {}

    func prepare(frame: CGImage) -> UIImage {
        let image = UIImage(cgImage: frame)
        snapshotImage = image
        return image.cropCenter()
    }
}
