//
//  KycHologramScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 12..
//

import Combine
import Foundation
import Resolver
import WebRTC
import DesignKit

class KycHologramScreenViewModel: ScreenViewModel<KycPageScreenEvent>, KycVideoScreenViewModelProtocol {
    @Published var shape: CameraFinderView.Shape = .rectangle
    @Published var state: CameraVideoOverlayView.ValidationState = .normal
    @Published var text: String? = Strings.Localizable.kycHologramInstruction
    @Published var ctaTitle: String? = Strings.Localizable.commonNext
    @Published var progress: Float?
    @Published var animation: CameraFinderView.Animation? = .init(kind: .hint, asset: .idTilt)
    var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }

    @Injected var draft: ReadOnly<KycDraft>
    @Injected var nextStep: ReadOnly<FaceKom.Step>
    @Injected var action: FaceKomAction
    @Injected var config: KycConfig
    private var disposeBag = Set<AnyCancellable>()

    private func subscribeEvents() {
        draft.publisher
            .map(\.stepProgress?.value)
            .assign(to: &$progress)

        $progress
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .filter { $0 == 1 }
            .map { _ in .loading }
            .assign(to: &$state)

        $state
            .filter { $0 == .loading }
            .sink(receiveValue: { [action] _ in
                action.setFlash(false)
                action.stopVideo()
            })
            .store(in: &disposeBag)

        draft.publisher
            .map(\.stepProgress?.message)
            .map { message -> String? in
                switch message {
                case "technicalError":
                    return Strings.Localizable.kycHologramCheckTechnicalError
                case "missingDocument":
                    return Strings.Localizable.kycHologramCheckMissingDocument
                case "outsideCorners":
                    return Strings.Localizable.kycHologramCheckOutsideCamera
                case "tooSmall":
                    return Strings.Localizable.kycHologramCheckTooSmall
                default:
                    return nil
                }
            }
            .handleEvents(receiveOutput: { [weak self] guide in
                if let guide = guide {
                    self?.state = .warning
                    self?.text = guide
                }
            })
            .map { guide -> AnyPublisher<String?, Never> in
                if guide == nil {
                    return Just(guide)
                        .eraseToAnyPublisher()
                } else {
                    return Just(guide)
                        .delay(for: 3, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .sink(receiveValue: { [weak self] _ in
                self?.state = .normal
                self?.text = Strings.Localizable.kycHologramCaptureInfo
            })
            .store(in: &disposeBag)

        nextStep.publisher
            .dropFirst()
            .handleEvents(receiveOutput: { [weak self] nextStep in
                if case .livenessCheck = nextStep {
                    self?.showError()
                } else {
                    self?.showSuccess()
                }
                self?.action.setFlash(false)
                self?.action.stopVideo()
            })
            .delay(for: 2, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.disposeBag.removeAll()
                self?.events.send(.proceed)
            })
            .store(in: &disposeBag)
    }

    private func showSuccess() {
        state = .success
        text = nil
    }

    private func showError() {
        state = .error
        text = Strings.Localizable.kycProcessFailed
    }

    func handle(_ event: KycVideoScreenInput) {
        switch event {
        case .onAppear(let videoView):
            startVideo(with: videoView)
            Just(config.useFlashOnHologramCheck)
                .delay(for: 3, scheduler: DispatchQueue.main)
                .sink(receiveValue: { [weak self] useFlash in
                    self?.animation = nil
                    self?.text = Strings.Localizable.kycHologramCaptureInfo
                    self?.subscribeEvents()
                    self?.action.startRecording()
                    self?.action.setFlash(useFlash)
                })
                .store(in: &disposeBag)
        }
    }

    private func startVideo(with videoView: RTCVideoRenderer) {
        action.startVideo(with: videoView, on: .back, startRecording: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] event in
                switch event {
                case .finished:
                    break
                case .failure:
                    self?.bottomAlertSubject.send(.genericError(onRetry: { [weak self] in
                        self?.startVideo(with: videoView)
                    }))
                }
            })
            .store(in: &disposeBag)
    }
}
