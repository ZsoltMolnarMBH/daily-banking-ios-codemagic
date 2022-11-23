//
//  KycLivenessCheckScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 07..
//

import Combine
import Foundation
import Resolver
import WebRTC
import DesignKit

class KycLivenessCheckScreenViewModel: ScreenViewModel<KycPageScreenEvent>, KycVideoScreenViewModelProtocol {
    @Published var shape: CameraFinderView.Shape = .capsule
    @Published var state: CameraVideoOverlayView.ValidationState = .normal
    @Published var text: String? = Strings.Localizable.kycLivenessCheckInstruction
    @Published var progress: Float?
    @Published var animation: CameraFinderView.Animation? = .init(kind: .hint, asset: .faceTheCamera)

    @Injected var draft: ReadOnly<KycDraft>
    @Injected var nextStep: ReadOnly<FaceKom.Step>
    @Injected var action: FaceKomAction
    @Injected var config: KycConfig
    private var disposeBag = Set<AnyCancellable>()
    @Published private var currentTask: FaceKomStepMessageDataTask?
    @Published private var guides = [String]()

    var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }

    private func subscribeEvents() {
        nextStep.publisher
            .dropFirst()
            .handleEvents(receiveOutput: { [weak self] nextStep in
                if case .livenessCheck = nextStep {
                    self?.showError()
                } else {
                    self?.showSuccess()
                }
                self?.action.stopVideo()
            })
            .delay(for: 2, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.disposeBag.removeAll()
                self?.events.send(.proceed)
            })
            .store(in: &disposeBag)

        draft.publisher
            .map(\.stepMessage)
            .dropFirst()
            .compactMap { $0 }
            .compactMap { message -> FaceKomStepMessageDataTask? in
                switch message {
                case .task(_, data: let task):
                    return task
                default:
                    return nil
                }
            }
            .assign(to: &$currentTask)

        $currentTask
            .map { $0?.text }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.guides.removeAll()
                self?.state = .normal
            })
            .dropFirst()
            .assign(to: &$text)

        $currentTask
            .receive(on: DispatchQueue.main)
            .map { task -> CameraFinderView.Animation? in
                if let animation = task?.animation {
                    return .init(kind: .task, asset: animation)
                }
                return nil
            }
            .assign(to: &$animation)

        draft.publisher
            .map(\.stepMessage)
            .dropFirst()
            .compactMap { $0 }
            .compactMap { message -> FaceKomStepMessageDataGuide? in
                switch message {
                case .guide(_, data: let guide):
                    return guide
                default:
                    return nil
                }
            }
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: { [weak self] guide in
                guard let self = self else { return }
                if let text = guide.text {
                    self.guides.append(text)
                } else {
                    self.guides.removeAll()
                }
            })
            .store(in: &disposeBag)

        $guides
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] guides in
                guard self?.state != .error else { return }
                if guides.count >= 2 {
                    self?.state = .warning
                    self?.text = guides.last
                } else {
                    self?.state = .normal
                    self?.text = self?.currentTask?.text ?? Strings.Localizable.kycLivenessCheckInstruction
                }
            }).store(in: &disposeBag)
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
            Just(())
                .delay(for: 3, scheduler: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.subscribeEvents()
                    self?.action.startRecording()
                })
                .store(in: &disposeBag)
        }
    }

    private func startVideo(with videoView: RTCVideoRenderer) {
        action.startVideo(with: videoView, on: .front, startRecording: false)
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

extension FaceKomStepMessageDataTask {
    var text: String? {
        switch self.instruction {
        case "look_right":
            return Strings.Localizable.kycLivenessCheckTaskLookRight
        case "look_left":
            return Strings.Localizable.kycLivenessCheckTaskLookLeft
        case "look_up":
            return Strings.Localizable.kycLivenessCheckTaskLookUp
        case "look_down":
            return Strings.Localizable.kycLivenessCheckTaskLookDown
        case "face":
            return Strings.Localizable.kycLivenessCheckTaskLookIntoCamera
        case "smile":
            return Strings.Localizable.kycLivenessCheckTaskSmile
        case "blink":
            return Strings.Localizable.kycLivenessCheckTaskBlink
        default:
            return nil
        }
    }

    var animation: ThemeAwareAnimation? {
        switch self.instruction {
        case "look_right":
            return .faceRight
        case "look_left":
            return .faceLeft
        case "look_up":
            return .faceUp
        case "look_down":
            return .faceDown
        case "face":
            return .faceTheCamera
        default:
            return nil
        }
    }
}

extension FaceKomStepMessageDataGuide {
    var text: String? {
        if self.instruction == "face_the_camera" {
            return Strings.Localizable.kycLivenessCheckTaskLookIntoCamera
        } else if self.instruction == "move_head_away" {
            return Strings.Localizable.kycLivenessCheckGuideMoveHeadAway
        } else if self.instruction == "move_head_closer" {
            return Strings.Localizable.kycLivenessCheckGuideMoveHeadCloser
        } else if self.instruction == "move_head_down"
                    || self.instruction == "move_head_up"
                    || self.instruction == "move_head_left"
                    || self.instruction == "move_head_right" {
            return Strings.Localizable.kycLivenessCheckGuideMoveHead
        } else if self.type == "head_tilt" {
            return Strings.Localizable.kycLivenessCheckGuideHeadTilt
        }
        return nil
    }
}
