//
//  FaxeKomActionTests.swift
//  DailyBankingTests
//
//  Created by ALi on 2022. 04. 03..
//

import XCTest
import UIKit
import Resolver
import Combine
import SwiftyMocky
import FaceKomSDK
import Apollo
import BankAPI
@testable import DailyBanking

class FaceKomActionTests: BaseTestCase {

    var apiMock: APIProtocolMock!
    var faceKomSelfService: FaceKomSelfServiceMock!
    var faceKomAction: FaceKomAction!
    var kycDraftStore: MemoryKycDraftStore!
    var kycStepStore: MemoryKycStepStore!
    var disposeBag: Set<AnyCancellable>!
    let eventPublisher: PassthroughSubject<FaceKom.Event, Never> = .init()

    override func setUp() {
        container = makeMainContainer()
            .makeChild()
            .assembled(using: KycAssembly())

        apiMock = .init()
        faceKomSelfService = .init()
        kycDraftStore = .init()
        kycStepStore = .init()
        
        container.register { self.apiMock as APIProtocol }
        container.register { self.faceKomSelfService as FaceKomSelfService }
        container.register { self.kycDraftStore as any KycDraftStore }
        container.register { self.kycStepStore as any KycStepStore }

        disposeBag = Set<AnyCancellable>()

        container.useContext {
            faceKomAction = FaceKomActionImpl()
        }
    }

    override func tearDown() {
        disposeBag = nil
    }

    func testNormalStartWorks() {
        // Given
        Given(faceKomSelfService, .isAuthorized(getter: false))
        generalFaceKomSelfServiceGivenSetup()

        let expectation = XCTestExpectation()

        // When
        faceKomAction.start().sink { result in
            switch result {
            case .finished:
                self.eventPublisher.send(.statusChange(status: .connected))
                expectation.fulfill()
            case .failure(let error):
                Failure("Result should be completed. \(error)")
            }
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .getSettings(baseUrl: "sdk-url"))
        Verify(faceKomSelfService, 1, .connectToSocket(baseUrl: .any, with: Parameter<FKSocketIOSettings>.matching({ param in
            param.path == "path" && param.transports == ["a", "b"] && param.connectTimeout == 5.0 && param.reconnect && param.maxReconnectAttempts == 5
        })))
        Verify(faceKomSelfService, 1, .auth(with: "sdk-token"))
        Verify(faceKomSelfService, 1, .startEventListening(with: Parameter<String>.any))
        Verify(faceKomSelfService, 1, .startFaceKom())
        Verify(apiMock, 1, .publisher(for: Parameter<GetKycEnvironmentQuery>.any, cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely)))

        XCTAssertEqual(kycDraftStore.state.value.socketStatus, .connected)
    }

    func testNormalWhenAlreadyAuthorized() {
        // Given
        Given(faceKomSelfService, .isAuthorized(getter: true))
        generalFaceKomSelfServiceGivenSetup()

        let expectation = XCTestExpectation()

        // When
        faceKomAction.start().sink { result in
            switch result {
            case .finished:
                self.eventPublisher.send(.statusChange(status: .connected))
                expectation.fulfill()
            case .failure(let error):
                Failure("Result should be completed. \(error)")
            }
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 0, .getSettings(baseUrl: .any))
        Verify(faceKomSelfService, 0, .connectToSocket(baseUrl: .any, with: Parameter<FKSocketIOSettings>.matching({ param in
            param.path == "path" && param.transports == ["a", "b"] && param.connectTimeout == 5.0 && param.reconnect && param.maxReconnectAttempts == 5
        })))
        Verify(faceKomSelfService, 0, .auth(with: Parameter<String>.any))
        Verify(faceKomSelfService, 0, .startEventListening(with: Parameter<String>.any))
        Verify(faceKomSelfService, 1, .startFaceKom())
        Verify(apiMock, 0, .publisher(for: Parameter<GetKycTokenQuery>.any, cachePolicy: Parameter<CachePolicy>.value(.fetchIgnoringCacheCompletely)))
    }

    func testStartWithSettingsErrorFails() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<GetKycEnvironmentQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(GetKycEnvironmentQuery.Data.init(getKycTokenV2: .init(sdkToken: "sdk-token", sdkUrl: "sdk-url"))))
        )
        Given(faceKomSelfService, .isAuthorized(getter: false))
        Given(faceKomSelfService, .getSettings(baseUrl: .any, willReturn: Fail(error: FaceKomSelfServiceError.invalidSettingsResponse).eraseToAnyPublisher()))

        let expectation = XCTestExpectation()

        // When
        faceKomAction.start().sink { result in
            switch result {
            case .finished:
                Failure("Function should be failed.")
            case .failure(let error):
                switch error {
                case .sdkError(let error):
                    if case FaceKomSelfServiceError.invalidSettingsResponse = error {
                        return expectation.fulfill()
                    } else {
                        break
                    }
                }
                Failure("Function should be failed with skdError(.invalidSettingsResponse).")
            }
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .getSettings(baseUrl: .any))
    }

    func testStartWithSDKErrorFails() {
        // Given
        Given(apiMock, .publisher(
            for: Parameter<GetKycEnvironmentQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: .just(GetKycEnvironmentQuery.Data.init(getKycTokenV2: .init(sdkToken: "sdk-token", sdkUrl: "sdk-url"))))
        )
        Given(faceKomSelfService, .isAuthorized(getter: false))
        Given(faceKomSelfService, .getSettings(baseUrl: .any, willReturn: Fail(error: NSError(domain: "a", code: 5)).eraseToAnyPublisher()))

        let expectation = XCTestExpectation()

        // When
        faceKomAction.start().sink { result in
            switch result {
            case .finished:
                Failure("Function should be failed.")
            case .failure(let error):
                switch error {
                case .sdkError(let error):
                    let error = error as NSError
                    if error.domain == "a", error.code == 5 {
                        return expectation.fulfill()
                    }
                }
                Failure("Invalid error type...")
            }
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .getSettings(baseUrl: .any))
    }

    func testStartSubscribesForEventsWorks() {
        // Given
        Given(faceKomSelfService, .isAuthorized(getter: false))
        generalFaceKomSelfServiceGivenSetup()

        let expectation = XCTestExpectation()
        Perform(faceKomSelfService, .startEventListening(with: Parameter<String>.any, perform: { _ in
            expectation.fulfill()
        }))

        // When
        faceKomAction.start().sink { result in
            switch result {
            case .finished:
                break
            case .failure:
                Failure("Function should be completed.")
            }
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)
    }

    func testEventHandlingWorks() {
        // Given
        Given(faceKomSelfService, .isAuthorized(getter: false))
        generalFaceKomSelfServiceGivenSetup()

        let stepProgressData = FaceKomStepProgressDataTest(stepType: "sT", value: 3.14)
        let stepMessageData = FaceKomStepMessageDataTaskTest(instruction: "i", message: "m")

        let expectation = XCTestExpectation()

        // When
        faceKomAction.start().sink { result in
            switch result {
            case .finished:
                self.eventPublisher.send(.statusChange(status: .disconnected))
                self.eventPublisher.send(.progressInfo(data: stepProgressData))
                self.eventPublisher.send(.stepMessage(message: .task(step: "step", data: stepMessageData)))
                self.eventPublisher.send(.nextStep(step: .idFront(isRetry: false)))
                expectation.fulfill()
            case .failure:
                Failure("Function should be completed.")
            }
        }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        XCTAssertEqual(kycDraftStore.state.value.socketStatus, .disconnected)
        XCTAssertEqual(kycDraftStore.state.value.stepProgress as? FaceKomStepProgressDataTest, stepProgressData)
        if case .task(let step, let data) = kycDraftStore.state.value.stepMessage, step == "step", data.message == stepMessageData.message {
            do { }
        } else {
            Failure("kycDraftStore.state.value.stepProgress has unexpectd value!")
        }
        if case .idFront = kycStepStore.state.value {
            do { }
        } else {
            Failure("kycDraftStore.state.value.nextStep has unexpectd value!")
        }
    }

    private func generalFaceKomSelfServiceGivenSetup() {
        let settingsPublisher: AnyPublisher<FKSocketIOSettings, Error> =
        Just(FKSocketIOSettings(path: "path", transports: ["a", "b"], connectionTimeout: 5.0, reconnect: true, maxReconnectAttempts: 5)).setFailureType(to: Error.self).eraseToAnyPublisher()
        Given(faceKomSelfService, .getSettings(baseUrl: .any, willReturn: settingsPublisher))

        let connectToSocketPublisher: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        Given(faceKomSelfService, .connectToSocket(baseUrl: .any, with: Parameter<FKSocketIOSettings>.any, willReturn: connectToSocketPublisher))

        let authPublisher: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        Given(faceKomSelfService, .auth(with: Parameter<String>.any, willReturn: authPublisher))

        Given(faceKomSelfService, .startEventListening(with: Parameter<String>.any, willReturn: eventPublisher.eraseToAnyPublisher()))

        let startPublisher: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        Given(faceKomSelfService, .startFaceKom(willReturn: startPublisher))

        let environmentQueryPublisher: AnyPublisher<GetKycEnvironmentQuery.Data, Error> = Just(.init(getKycTokenV2: .init(sdkToken: "sdk-token", sdkUrl: "sdk-url")))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        Given(apiMock, .publisher(
            for: Parameter<GetKycEnvironmentQuery>.any,
            cachePolicy: Parameter<CachePolicy>.any,
            willReturn: environmentQueryPublisher)
        )
    }

    func testStartVideoCaptureSessionFails() {
        // Given
        Given(faceKomSelfService, .setCamera(camera: Parameter<FaceKom.Camera>.value(.front), willReturn: Fail(error: TestError.simple).eraseToAnyPublisher()))
        let initStreamResultPublisher: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        Given(faceKomSelfService, .initStream(localVideoView: Parameter<RTCVideoRenderer>.any, startRecording: false, willReturn: initStreamResultPublisher))
        kycDraftStore.modify { $0.socketStatus = .connected }
        let expectation = XCTestExpectation()

        // When
        faceKomAction.startVideo(with: RTCEAGLVideoView(), on: .front, startRecording: false)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("StartVideo should be failed!")
                case .failure:
                    expectation.fulfill()
                }
            })
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .setCamera(camera: Parameter<FaceKom.Camera>.value(.front)))
        Verify(faceKomSelfService, 0, .initStream(localVideoView: Parameter<RTCVideoRenderer>.any, startRecording: false))
    }

    func testStartVideoCaptureSessionWorks() {
        // Given
        Given(faceKomSelfService, .setCamera(camera: Parameter<FaceKom.Camera>.value(.front), willReturn: Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()))
        let initStreamResultPublisher: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        Given(faceKomSelfService, .initStream(localVideoView: Parameter<RTCVideoRenderer>.any, startRecording: false, willReturn: initStreamResultPublisher))
        kycDraftStore.modify { $0.socketStatus = .connected }
        let expectation = XCTestExpectation()

        // When
        faceKomAction.startVideo(with: RTCEAGLVideoView(), on: .front, startRecording: false)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("StartVideo should be completed!")
                }
            })
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .setCamera(camera: Parameter<FaceKom.Camera>.value(.front)))
        Verify(faceKomSelfService, 1, .initStream(localVideoView: Parameter<RTCVideoRenderer>.any, startRecording: false))
    }

    func testStartRecording() {
        // Given
        Given(faceKomSelfService, .startRecording(willReturn: true))
        // When
        faceKomAction.startRecording()

        // Then
        Verify(faceKomSelfService, 1, .startRecording())
    }

    func testStopVideo() {
        // Given
        // When
        faceKomAction.stopVideo()

        // Then
        Verify(faceKomSelfService, 1, .stopRecording())
    }

    func testSetFlash() {
        // Given
        // When
        faceKomAction.setFlash(true)

        // Then
        Verify(faceKomSelfService, 1, .setFlash(true))
    }

    func testReadNFCWorks() {
        // Given
        Given(faceKomSelfService, .isAuthorized(getter: false))
        Given(faceKomSelfService, .readNFC(messageProvider: .any, willReturn: Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()))
        kycDraftStore.modify { $0.socketStatus = .connected }
        let expectation = XCTestExpectation()

        // When
        faceKomAction.readNFC(messageProvider: { _ in "" })
            .sink { result in
                if case .failure(let error) = result {
                    XCTFail("faceKomAction.readNFC() failed! \(error)")
                }
                expectation.fulfill()
            }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)
    }

    func testReadNFCFailed() {
        // Given
        Given(faceKomSelfService, .isAuthorized(getter: false))
        Given(faceKomSelfService, .readNFC(messageProvider: .any, willReturn: Fail(error: TestError.simple).eraseToAnyPublisher()))
        kycDraftStore.modify { $0.socketStatus = .connected }
        let expectation = XCTestExpectation()

        // When
        faceKomAction.readNFC(messageProvider: { _ in "" })
            .sink { result in
                switch result {
                case .finished:
                    XCTFail("faceKomAction.readNFC() should be failed")
                case .failure(let error):
                    if case .sdkError = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("faceKomAction.readNFC() invalid error type")
                    }
                }
            }.store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)
    }

    func testSkipCurrentStepFailed() {
        // Given
        Given(faceKomSelfService, .skipCurrentStep(willReturn: Fail(error: TestError.simple).eraseToAnyPublisher()))
        let expectation = XCTestExpectation()

        // When
        faceKomAction.skipCurrentStep().sink { result in
            if case .failure = result {
                return expectation.fulfill()
            }
            XCTFail("faceKomAction.skipCurrentStep() should be failed")
        }.store(in: &self.disposeBag)

        wait(for: [expectation], timeout: 4)
    }

    func testSkipCurrentStepWorks() {
        // Given
        Given(faceKomSelfService, .skipCurrentStep(willReturn: Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()))
        let expectation = XCTestExpectation()

        faceKomAction.skipCurrentStep().sink { result in
            if case .failure(let error) = result {
                XCTFail("faceKomAction.skipCurrentStep() failed! \(error)")
            }
            expectation.fulfill()
        }.store(in: &self.disposeBag)

        wait(for: [expectation], timeout: 4)
    }

    func testStopFailed() {
        // Given
        Given(faceKomSelfService, .stop(willReturn: Fail(error: TestError.simple).eraseToAnyPublisher()))
        let expectation = XCTestExpectation()

        // When
        faceKomAction.stop().sink { result in
            if case .finished = result {
                XCTFail("faceKomAction.stop() should be failed")
            }
            expectation.fulfill()
        }.store(in: &self.disposeBag)

        wait(for: [expectation], timeout: 4)
    }

    func testStopWorks() {
        // Given
        Given(faceKomSelfService, .stop(willReturn: Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()))
        let expectation = XCTestExpectation()

        // When
        faceKomAction.stop().sink { result in
            if case .failure = result {
                XCTFail("faceKomAction.stop() failed")
            }
            expectation.fulfill()
        }.store(in: &self.disposeBag)

        wait(for: [expectation], timeout: 4)
    }

    func testPhotoUploadFails_retryable() {
        // Given
        let uploadResponsePublisher: AnyPublisher<FaceKomPhotoUploadResponse, Error> = Just(
            FaceKomPhotoUploadResponseTest(
                attachmentID: nil,
                action: FaceKomPhotoUploadResponseActionsTest(isRetryEnabled: true, isSubmitEnabled: false, isRecongnitionValid: false),
                response: nil)
        ).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        Given(faceKomSelfService, .uploadPhoto(image: Parameter<UIImage>.any, willReturn: uploadResponsePublisher))
        let expectation = XCTestExpectation()

        faceKomAction.upload(image: UIImage())
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("response should be failed!")
                case .failure(let error):
                    if case let FaceKomActionPhotoUploadError.genericError(isRetryable: retryable) = error {
                        XCTAssert(retryable == true)
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .uploadPhoto(image: .any))
        Verify(faceKomSelfService, 0, .finalizePhoto(with: .any))
    }

    func testPhotoUpload_portrait_no_face() {
        // Given
        let responseData: [String: Any] = ["recognitionError": ["message": "face_missing"]]
        let uploadResponsePublisher: AnyPublisher<FaceKomPhotoUploadResponse, Error> = Just(
            FaceKomPhotoUploadResponseTest(
                attachmentID: 1,
                action: FaceKomPhotoUploadResponseActionsTest(isRetryEnabled: true, isSubmitEnabled: false, isRecongnitionValid: false),
                response: responseData)
        ).setFailureType(to: Error.self).eraseToAnyPublisher()

        Given(faceKomSelfService, .uploadPhoto(image: Parameter<UIImage>.any, willReturn: uploadResponsePublisher))
        let expectation = XCTestExpectation()

        faceKomAction.upload(image: UIImage())
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("response should be failed!")
                case .failure(let error):
                    if case FaceKomActionPhotoUploadError.portraitFaceIsMissing = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .uploadPhoto(image: .any))
        Verify(faceKomSelfService, 0, .finalizePhoto(with: .any))
    }

    func testPhotoUpload_portrait_move_closer() {
        // Given
        let responseData: [String: Any] = ["recognitionError": ["message": "move_head_closer"]]
        let uploadResponsePublisher: AnyPublisher<FaceKomPhotoUploadResponse, Error> = Just(
            FaceKomPhotoUploadResponseTest(
                attachmentID: 1,
                action: FaceKomPhotoUploadResponseActionsTest(isRetryEnabled: true, isSubmitEnabled: false, isRecongnitionValid: false),
                response: responseData)
        ).setFailureType(to: Error.self).eraseToAnyPublisher()

        Given(faceKomSelfService, .uploadPhoto(image: Parameter<UIImage>.any, willReturn: uploadResponsePublisher))
        let expectation = XCTestExpectation()

        faceKomAction.upload(image: UIImage())
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("response should be failed!")
                case .failure(let error):
                    if case FaceKomActionPhotoUploadError.portraitMoveHeadCloser = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .uploadPhoto(image: .any))
        Verify(faceKomSelfService, 0, .finalizePhoto(with: .any))
    }

    func testPhotoUpload_portrait_move_away() {
        // Given
        let responseData: [String: Any] = ["recognitionError": ["message": "move_head_away"]]
        let uploadResponsePublisher: AnyPublisher<FaceKomPhotoUploadResponse, Error> = Just(
            FaceKomPhotoUploadResponseTest(
                attachmentID: 1,
                action: FaceKomPhotoUploadResponseActionsTest(isRetryEnabled: true, isSubmitEnabled: false, isRecongnitionValid: false),
                response: responseData)
        ).setFailureType(to: Error.self).eraseToAnyPublisher()

        Given(faceKomSelfService, .uploadPhoto(image: Parameter<UIImage>.any, willReturn: uploadResponsePublisher))
        let expectation = XCTestExpectation()

        faceKomAction.upload(image: UIImage())
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("response should be failed!")
                case .failure(let error):
                    if case FaceKomActionPhotoUploadError.portraitMoveHeadAway = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .uploadPhoto(image: .any))
        Verify(faceKomSelfService, 0, .finalizePhoto(with: .any))
    }

    func testPhotoUpload_submit_disabled() {
        // Given
        let responseData: [String: Any] = [:]
        let uploadResponsePublisher: AnyPublisher<FaceKomPhotoUploadResponse, Error> = Just(
            FaceKomPhotoUploadResponseTest(
                attachmentID: 1,
                action: FaceKomPhotoUploadResponseActionsTest(isRetryEnabled: true, isSubmitEnabled: false, isRecongnitionValid: false),
                response: responseData)
        ).setFailureType(to: Error.self).eraseToAnyPublisher()

        Given(faceKomSelfService, .uploadPhoto(image: Parameter<UIImage>.any, willReturn: uploadResponsePublisher))
        let expectation = XCTestExpectation()

        faceKomAction.upload(image: UIImage())
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("response should be failed!")
                case .failure(let error):
                    switch error {
                    case .genericError(let retryable):
                        guard retryable else { return XCTFail("Invalid retryable flag") }
                        expectation.fulfill()
                    default:
                        XCTFail("Invalid error type")
                    }
                }
            }
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .uploadPhoto(image: .any))
        Verify(faceKomSelfService, 0, .finalizePhoto(with: .any))
    }

    func testPhotoUploadSuccess() {
        // Given
        let attachmentID = 12
        let uploadResponsePublisher: AnyPublisher<FaceKomPhotoUploadResponse, Error> = Just(
            FaceKomPhotoUploadResponseTest(
                attachmentID: attachmentID,
                action: FaceKomPhotoUploadResponseActionsTest(isRetryEnabled: true, isSubmitEnabled: true, isRecongnitionValid: false),
                response: nil)
        ).setFailureType(to: Error.self).eraseToAnyPublisher()

        Given(faceKomSelfService, .uploadPhoto(image: Parameter<UIImage>.any, willReturn: uploadResponsePublisher))
        Given(faceKomSelfService, .finalizePhoto(with: 12, willReturn: Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()))
        let expectation = XCTestExpectation()

        // When
        faceKomAction.upload(image: UIImage())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("response should be success!")
                }
            })
            .store(in: &disposeBag)

        wait(for: [expectation], timeout: 4)

        // Then
        Verify(faceKomSelfService, 1, .uploadPhoto(image: .any))
        Verify(faceKomSelfService, 1, .finalizePhoto(with: .value(attachmentID)))
    }

    func testConfirmDataFailed() {
        // Given
        Given(faceKomSelfService, .confirm(fields: .any, willReturn: Fail(error: TestError.simple).eraseToAnyPublisher()))
        let expectation = XCTestExpectation()

        // When
        faceKomAction.confirmData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Should be failed...")
                case .failure:
                    expectation.fulfill()
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(faceKomSelfService, 1, .confirm(fields: .any))
    }

    func testConfirmDataSuccess() {
        // Given
        Given(faceKomSelfService, .confirm(fields: .any, willReturn: Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()))
        let expectation = XCTestExpectation()

        // When
        faceKomAction.confirmData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Should be finished")
                }
            })
            .store(in: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 4)
        Verify(faceKomSelfService, 1, .confirm(fields: .any))
    }

    func testUpdateName() {
        // Given
        let legalName: Name = .init(firstName: "firstname", lastName: "lastName")
        let birthName = "birthName"
        let place = "plave"
        let birthDate = Date()
        let motherName = "motherName"

        // When
        faceKomAction.update(
            legalName: legalName,
            birthName: birthName,
            birthData: .init(place: place, date: birthDate, motherName: motherName)
        )

        // Then
        XCTAssertEqual(kycDraftStore.state.value.fields.firstName.value, legalName.firstName)
        XCTAssertEqual(kycDraftStore.state.value.fields.lastName.value, legalName.lastName)
        XCTAssertEqual(kycDraftStore.state.value.fields.birthName.value, birthName)
        XCTAssertEqual(kycDraftStore.state.value.fields.placeOfBirth.value, place)
        XCTAssertEqual(kycDraftStore.state.value.fields.dateOfBirth.value, DateFormatter.simple.string(from: birthDate))
        XCTAssertEqual(kycDraftStore.state.value.fields.motherName.value, motherName)
    }

    func testUpdateAddress() {
        // Given
        let address = "Address"

        // When
        faceKomAction.update(legalAddress: address)

        // Then
        XCTAssertEqual(kycDraftStore.state.value.fields.address.value, address)
    }

    func testUpdateDocuments() {
        // Given
        let idNumber = "123123AA"
        let validity = Date()
        let addressCardNumber = "123123AA"

        // When
        faceKomAction.update(idNumber: idNumber, idValidity: validity, addressCardNumber: addressCardNumber)

        // Then
        XCTAssertEqual(kycDraftStore.state.value.fields.idCardNumber.value, idNumber)
        XCTAssertEqual(kycDraftStore.state.value.fields.idDateOfExpiry.value, DateFormatter.simple.string(from: validity))
        XCTAssertEqual(kycDraftStore.state.value.fields.addressCardNumber.value, addressCardNumber)
    }
}

private struct FaceKomStepProgressDataTest: FaceKomStepProgressData, Equatable {
    var stepType: String
    var value: Float
    var message: String?
}

private struct FaceKomStepMessageDataTaskTest: FaceKomStepMessageDataTask, Equatable {
    var instruction: String
    var message: String?
}

private struct FaceKomPhotoUploadResponseTest: FaceKomPhotoUploadResponse {
    var attachmentID: Int?
    var action: FaceKomPhotoUploadResponseActions
    var response: [String : Any]?
}

private struct FaceKomPhotoUploadResponseActionsTest: FaceKomPhotoUploadResponseActions {
    var isRetryEnabled: Bool
    var isSubmitEnabled: Bool
    var isRecongnitionValid: Bool
}
