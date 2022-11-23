//
//  FaceKomAction.swift
//  FaceKomPOCUIKit
//
//  Created by ALi on 2022. 03. 20..
//

import Foundation
import FaceKomSDK
import Combine
import WebRTC
import Resolver
import BankAPI

protocol FaceKomAction {
    func start() -> AnyPublisher<Never, FaceKomActionError>
    func stop() -> AnyPublisher<Never, FaceKomActionError>
    func skipCurrentStep() -> AnyPublisher<Never, FaceKomActionError>
    func startVideo(with webRTCVideoView: RTCVideoRenderer, on camera: FaceKom.Camera, startRecording: Bool) -> AnyPublisher<Never, FaceKomActionError>
    func upload(image: UIImage) -> AnyPublisher<Never, FaceKomActionPhotoUploadError>
    func readNFC(messageProvider: @escaping FaceKom.NFCMessageProvider) -> AnyPublisher<Never, FaceKomActionError>
    func confirmData() -> AnyPublisher<Never, FaceKomActionError>
    func reportKycFinished() -> AnyPublisher<Never, ActionError<ResponseStatusError>>

    func setFlash(_ isOn: Bool)
    func startRecording()
    func stopVideo()

    func update(legalName: Name, birthName: String?, birthData: BirthData)
    func update(legalAddress: String)
    func update(idNumber: String, idValidity: Date?, addressCardNumber: String)
}

enum FaceKomActionError: Error {
    case sdkError(error: Error)
}

enum FaceKomActionPhotoUploadError: Error {
    case genericError(isRetryable: Bool)
    case portraitFaceIsMissing
    case portraitMoveHeadCloser
    case portraitMoveHeadAway
    case sdkError(Error)
}

class FaceKomActionImpl: FaceKomAction {

    @Injected var api: APIProtocol
    @Injected var selfService: FaceKomSelfService
    @Injected var kycDraftStore: any KycDraftStore
    @Injected var kycStepStore: any KycStepStore
    @Injected var individualInputMapper: Mapper<FaceKom.DataConfirmationFields, IndividualInput>

    private var disposeBag: Set<AnyCancellable> = .init()

    func start() -> AnyPublisher<Never, FaceKomActionError> {
        let task: AnyPublisher<Void, Error>
        if selfService.isAuthorized {
            task = selfService.startFaceKom()
        } else {
            task = getKycEnvironment().flatMap { [selfService] environment in
                selfService.getSettings(baseUrl: environment.baseUrl).map { ($0, environment) }
            }
            .flatMap { [weak self, selfService] (settings, environment) -> AnyPublisher<FaceKom.Environment, Error> in
                selfService.connectToSocket(baseUrl: environment.baseUrl, with: settings)
                    .handleEvents(receiveOutput: { self?.subscribeForEvents() })
                    .map { environment }
                    .eraseToAnyPublisher()
            }.flatMap { [selfService] environment in
                selfService.auth(with: environment.token)
            }.flatMap { [selfService] _ -> AnyPublisher<Void, Error> in
                selfService.startFaceKom()
            }.eraseToAnyPublisher()
        }

        return task
            .mapError { FaceKomActionError.sdkError(error: $0) }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func stopVideo() {
        selfService.stopRecording()
    }

    func startVideo(with webRTCVideoView: RTCVideoRenderer, on camera: FaceKom.Camera, startRecording: Bool) -> AnyPublisher<Never, FaceKomActionError> {
        selfService
            .setCamera(camera: camera)
            .flatMap { [selfService] _ in
                selfService.initStream(localVideoView: webRTCVideoView, startRecording: startRecording)
            }
            .mapError { FaceKomActionError.sdkError(error: $0) }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func setFlash(_ isOn: Bool) {
        selfService.setFlash(isOn)
    }

    func startRecording() {
        _ = selfService.startRecording()
    }

    func upload(image: UIImage) -> AnyPublisher<Never, FaceKomActionPhotoUploadError> {
        selfService
            .uploadPhoto(image: image)
            .tryMap { uploadResponse -> Int in
                guard let attachmentId = uploadResponse.attachmentID else {
                    throw FaceKomActionPhotoUploadError.genericError(isRetryable: true)
                }
                if let recognitionErrors = uploadResponse.response?["recognitionError"] as? [String: Any],
                    let message = recognitionErrors["message"] as? String {
                    switch message {
                    case "face_missing":
                        throw FaceKomActionPhotoUploadError.portraitFaceIsMissing
                    case "move_head_closer":
                        throw FaceKomActionPhotoUploadError.portraitMoveHeadCloser
                    case "move_head_away":
                        throw FaceKomActionPhotoUploadError.portraitMoveHeadAway
                    default:
                        break
                    }
                }
                guard uploadResponse.action.isSubmitEnabled else {
                    throw FaceKomActionPhotoUploadError.genericError(isRetryable: uploadResponse.action.isRetryEnabled)
                }
                return attachmentId
            }
            .flatMap { [selfService] attachmentId in
                selfService.finalizePhoto(with: attachmentId)
            }
            .mapError { error -> FaceKomActionPhotoUploadError in
                guard let error = error as? FaceKomActionPhotoUploadError else { return .sdkError(error) }
                return error
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func readNFC(messageProvider: @escaping FaceKom.NFCMessageProvider) -> AnyPublisher<Never, FaceKomActionError> {
        selfService
            .readNFC(messageProvider: messageProvider)
            .mapError { FaceKomActionError.sdkError(error: $0) }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func confirmData() -> AnyPublisher<Never, FaceKomActionError> {
        selfService.confirm(fields: kycDraftStore.state.value.fields)
            .mapError { FaceKomActionError.sdkError(error: $0) }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func skipCurrentStep() -> AnyPublisher<Never, FaceKomActionError> {
        selfService
            .skipCurrentStep()
            .mapError { FaceKomActionError.sdkError(error: $0) }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func stop() -> AnyPublisher<Never, FaceKomActionError> {
        selfService.stop()
            .mapError { FaceKomActionError.sdkError(error: $0) }
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func reportKycFinished() -> AnyPublisher<Never, ActionError<ResponseStatusError>> {
        Just(kycDraftStore.state.value.fields)
            .tryMap { [individualInputMapper] fields in
                try individualInputMapper.map(fields)
            }
            .flatMap { [api] input in
                api.publisher(for: UpdateApplicationMutation(application: .init(individual: input)))
            }
            .tryMap { response -> Void in
                if response.updateApplication.status == .ok {
                    return ()
                }
                throw ResponseStatusError.statusFailed
            }
            .mapActionError(to: ResponseStatusError.self)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func update(legalName: Name, birthName: String?, birthData: BirthData) {
        var fields = kycDraftStore.state.value.fields
        fields.firstName.value = legalName.firstName
        fields.lastName.value = legalName.lastName
        fields.birthName.value = birthName ?? ""
        fields.motherName.value = birthData.motherName ?? ""
        fields.placeOfBirth.value = birthData.place ?? ""
        fields.dateOfBirth.value = DateFormatter.simple.string(optional: birthData.date) ?? ""

        kycDraftStore.modify {
            $0.fields = fields
        }
    }

    func update(legalAddress: String) {
        var fields = kycDraftStore.state.value.fields
        fields.address.value = legalAddress
        kycDraftStore.modify {
            $0.fields = fields
        }
    }

    func update(idNumber: String, idValidity: Date?, addressCardNumber: String) {
        var fields = kycDraftStore.state.value.fields
        fields.idCardNumber.value = idNumber
        fields.idDateOfExpiry.value = DateFormatter.simple.string(optional: idValidity) ?? ""
        fields.addressCardNumber.value = addressCardNumber

        kycDraftStore.modify {
            $0.fields = fields
        }
    }

    private func subscribeForEvents() {
        selfService.startEventListening(with: UUID().uuidString).sink { [kycDraftStore, kycStepStore] event in
            switch event {
            case .statusChange(let status):
                kycDraftStore.modify({ kycDraft in
                    kycDraft.socketStatus = status
                })
            case .nextStep(let step):
                kycStepStore.modify({ kycStep in
                    kycStep = step
                })
            case .progressInfo(let data):
                kycDraftStore.modify({ kycDraft in
                    kycDraft.stepProgress = data
                })
            case .stepMessage(let message):
                kycDraftStore.modify({ kycDraft in
                    kycDraft.stepMessage = message
                })
            }
        }.store(in: &disposeBag)
    }

    private func getKycEnvironment() -> AnyPublisher<FaceKom.Environment, Error> {
        let query = GetKycEnvironmentQuery()
        return api
            .publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            .map({ result in
                return FaceKom.Environment(
                    baseUrl: result.getKycTokenV2.sdkUrl,
                    token: result.getKycTokenV2.sdkToken
                )
            })
            .eraseToAnyPublisher()
    }
}
