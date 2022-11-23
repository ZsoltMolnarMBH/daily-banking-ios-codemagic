//
//  FaceKomProviding.swift
//  DailyBanking
//
//  Created by ALi on 2022. 03. 31..
//

import Foundation
import Combine
import FaceKomSDK
import Resolver

protocol FaceKomSelfService: AutoMockable {
    var isAuthorized: Bool { get }

    func getSettings(baseUrl: String) -> AnyPublisher<FKSocketIOSettings, Error>
    func connectToSocket(baseUrl: String, with settings: FKSocketIOSettings) -> AnyPublisher<Void, Error>
    func auth(with token: String) -> AnyPublisher<Void, Error>
    func register(userData: FKUserData) -> AnyPublisher<String, Error>
    func startFaceKom() -> AnyPublisher<Void, Error>
    func readNFC(messageProvider: @escaping FaceKom.NFCMessageProvider) -> AnyPublisher<Void, Error>

    func initStream(localVideoView: RTCVideoRenderer, startRecording: Bool) -> AnyPublisher<Void, Error>
    func uploadPhoto(image: UIImage) -> AnyPublisher<FaceKomPhotoUploadResponse, Error>
    func finalizePhoto(with attachmentId: Int) -> AnyPublisher<Void, Error>
    func setCamera(camera: FaceKom.Camera) -> AnyPublisher<Void, Error>
    func setFlash(_ isOn: Bool)
    func confirm(fields: FaceKom.DataConfirmationFields) -> AnyPublisher<Void, Error>
    func startRecording() -> Bool
    func stopRecording()

    func startEventListening(with identifier: String) -> AnyPublisher<FaceKom.Event, Never>
    func skipCurrentStep() -> AnyPublisher<Void, Error>
    func stop() -> AnyPublisher<Void, Error>
}

enum FaceKomSelfServiceError: Error {
    case invalidSettingsResponse
    case imageCompressionFailed
}

class FaceKomSelfServiceImpl: FaceKomSelfService {

    private let selfService = FKSelfService()
    private let eventSubject = PassthroughSubject<FaceKom.Event, Never>()

    var isAuthorized: Bool { selfService.getToken() != nil }

    func getSettings(baseUrl: String) -> AnyPublisher<FKSocketIOSettings, Error> {
        Future<FKSocketIOSettings, Error> { [selfService] promise in
            selfService.getSettings(settingsUrl: "\(baseUrl)/api/mobile/settings", certificates: nil) { result in
                guard let socketIOSettings = result.socketIOSettings else {
                    promise(.failure(FaceKomSelfServiceError.invalidSettingsResponse))
                    return
                }
                promise(.success(socketIOSettings))
            } onError: { error in
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func connectToSocket(baseUrl: String, with settings: FKSocketIOSettings) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.connectSocket(
                baseUrl: baseUrl,
                socketSettings: settings
            ) { _ in
                promise(.success(()))
            } onError: { error in
                promise(.failure(error))
            }

        }
        .eraseToAnyPublisher()
    }

    func auth(with token: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.auth(token: token) { _ in
                promise(.success(()))
            } onError: { error in
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func register(userData: FKUserData) -> AnyPublisher<String, Error> {
        Future<String, Error> { [selfService] promise in
            selfService.register(userData: userData) { result in
                promise(.success(result.token))
            } onError: { error in
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func startFaceKom() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.start(data: nil) { _ in
                promise(.success(()))
            } onError: { error in
                if error == .alreadyHasRoom {
                    promise(.success(()))
                } else {
                    promise(.failure(error))
                }
            }

        }
        .eraseToAnyPublisher()
    }

    func initStream(localVideoView: RTCVideoRenderer, startRecording: Bool) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.initCapturer(localVideoView: localVideoView, start: startRecording, isMuted: true) { _ in
                promise(.success(()))
            } onError: { error in
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func startRecording() -> Bool {
        switch selfService.startCapture() {
        case .success:
            return true
        default:
            return false
        }
    }

    func readNFC(messageProvider: @escaping FaceKom.NFCMessageProvider) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            let totalGroups = 8
            var currentGroup = -1
            var groupIndex = -1
            return selfService.readeMRTD(customDisplayMessage: { message in
                let step: FaceKom.NFCDisplayMessage
                switch message {
                case .requestPresentPassport:
                    step = .requestPresentPassport
                case .authenticatingWithPassport(let progress):
                    step = .authenticatingWithPassport(progress: progress)
                case .readingDataGroupProgress(let dataGroup, let progress):
                    if currentGroup != dataGroup.rawValue {
                        groupIndex += 1
                        currentGroup = dataGroup.rawValue
                    }
                    let totalProgress = ((100 / totalGroups) * groupIndex) + (progress / totalGroups)
                    step = .readingDataGroupProgress(progress: totalProgress)
                case .error:
                    step = .error
                case .successfulRead:
                    step = .successfulRead
                @unknown default:
                    return ""
                }
                return messageProvider(step)
            }, onCompleted: { _ in
                promise(.success(()))
            }, onError: { error in
                promise(.failure(error))
            })
        }.eraseToAnyPublisher()
    }

    func uploadPhoto(image: UIImage) -> AnyPublisher<FaceKomPhotoUploadResponse, Error> {
        Future<FaceKomPhotoUploadResponse, Error> { [selfService] promise in
            guard let data = image.jpegData(compressionQuality: 0.9),
                  let compressed = UIImage(data: data) else {
                promise(.failure(FaceKomSelfServiceError.imageCompressionFailed))
                return
            }
            selfService.uploadPhoto(image: compressed) { result in
                promise(.success(result))
            } onError: { error in
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func finalizePhoto(with attachmentId: Int) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.finalizePhoto(attachmentID: attachmentId) { _ in
                promise(.success(()))
            } onError: { error in
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func setCamera(camera: FaceKom.Camera) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.setCamera(camera: .init(from: camera))
            promise(.success(()))
        }.eraseToAnyPublisher()
    }

    func setFlash(_ isOn: Bool) {
        selfService.setFlash(mode: isOn ? .on(level: 1) : .off)
    }

    func confirm(fields: FaceKom.DataConfirmationFields) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [selfService] promise in
            selfService.setInput(inputData: .dataConfirmation(input: fields.dictionary), onCompleted: { _ in
                promise(.success(()))
            }, onError: { error in
                promise(.failure(error))
            })
        }.eraseToAnyPublisher()
    }

    func stopRecording() {
        selfService.stopCapture()
    }

    func stop() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.stop { _ in
                promise(.success(()))
            } onError: { error in
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func startEventListening(with identifier: String) -> AnyPublisher<FaceKom.Event, Never> {
        selfService.setListener(identifier: identifier) { [weak self] event in
            guard let event = FaceKom.Event(from: event) else { return }
            self?.eventSubject.send(event)
        }

        return eventSubject.eraseToAnyPublisher()
    }

    func skipCurrentStep() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [selfService] promise in
            selfService.skipStep { _ in
                promise(.success(()))
            } onError: { error in
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

extension FKCamera {
    init(from camera: FaceKom.Camera) {
        switch camera {
        case .front:
            self = .front
        case .back:
            self = .back
        }
    }
}

extension FaceKomSocketStatus {
    init(from status: FaceKom.SocketStatus) {
        switch status {
        case .undetermined, .notConnected:
            self = .notConnected
        case .disconnected:
            self = .disconnected
        case .connecting:
            self = .connecting
        case .connected:
            self = .connected
        }
    }
}
