//
//  SecondLevelAuth.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 04..
//

import Combine
import CryptoSwift
import Resolver

class SecondLevelAuthViewModel: BasePinEnterScreenViewModel {
    @Injected private var authKeyStore: any AuthenticationKeyStore
    @Injected private var device: DeviceInformation
    @Injected private var otpGenerator: OtpGenerator
    @Injected private var userAction: UserAction

    let passthroughSubject = PassthroughSubject<Result<Void, PinVerificationError>, Never>()
    private var _publisher = PassthroughSubject<SecondLevelAuthentication.Event, Never>()
    var publisher: AnyPublisher<SecondLevelAuthentication.Event, Never> {
        _publisher.eraseToAnyPublisher()
    }

    var onForceLogout: (() -> Void)?
    var onFinish: (() -> Void)?

    deinit {
        _publisher.send(.cancel)
    }

    override init() {
        super.init()
        passthroughSubject
            .sink(receiveValue: { [weak self] event in
                switch event {
                case .success:
                    self?._publisher.send(completion: .finished)
                    self?.onFinish?()
                case .failure(let error):
                    switch error {
                    case .invalidPin(remainingAttempts: let attempts):
                        self?.showError(message: AttributedString(Strings.Localizable.genericAuthenticationError(attempts)))
                    case .forceLogout:
                        self?.onForceLogout?()
                        self?.userAction.logout().fireAndForget()
                    }
                }
            })
            .store(in: &disposeBag)
    }

    override func onPinEntered(pin: PinCode) {
        guard let authKey = authKeyStore.state.value else { return }
        pinState = .disabled
        Just((otpGenerator, device.id.sha512()))
            .receive(on: DispatchQueue(label: UUID().uuidString))
            .tryMap { otpGenerator, deviceId -> String in
                try otpGenerator.createOtp(
                    keyFile: authKey.keyFile,
                    mpin: pin.stringValue,
                    deviceId: deviceId
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .finished:
                    break
                case .failure:
                    self?.showError(message: AttributedString(Strings.Localizable.commonGenericErrorRetry))
                }
            } receiveValue: { [weak self] otp in
                self?._publisher.send(.otpCreated(otp))
            }
            .store(in: &disposeBag)
    }
}
