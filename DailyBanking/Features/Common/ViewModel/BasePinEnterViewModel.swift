//
//  BasePinEnterScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 15..
//

import Combine
import LocalAuthentication
import Resolver

class BasePinEnterScreenViewModel: PinPadScreenViewModelProtocol {
    @Injected(container: .root) var pinStore: BiometricAuthStore
    @Injected(container: .root) var resetAction: ResetAction

    let maxDigitCount: Int = 6
    @Published var title = Strings.Localizable.loginPinTitle
    @Published var hint: String? = Strings.Localizable.loginPinForgottenPin
    @Published var isLoading: Bool = false
    @Published var supportedBiometryType: LABiometryType = .none
    @Published var pin: PinCode = []
    @Published var pinError: AttributedString?
    @Published var pinState: PinState = .editing
    @Published var alert: AlertModel?
    @Published var analyticsName: String = ""

    private var authContext = LAContext.new
    var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }

    var disposeBag = Set<AnyCancellable>()

    init() {
        $pin
            .sink { [weak self] in
                self?.handle(pin: $0)
            }
            .store(in: &disposeBag)

        pinStore
            .isPinCodeSaved
            .replaceError(with: false)
            .map { [authContext] isSaved in
                if isSaved
                    && (authContext.biometryAvailability == .available || authContext.biometryAvailability == .biometryLocked) {
                    return authContext.biometryType
                } else {
                    return .none
                }
            }
            .assign(to: \.supportedBiometryType, onWeak: self)
            .store(in: &disposeBag)

        $supportedBiometryType.sink { [weak self] biometryType in
            if biometryType != .none {
                self?.biometricAuthentication()
            }
        }.store(in: &disposeBag)
    }

    func handle(input: PinPadScreenInput) {
        switch input {
        case .biometricAuthRequested:
            biometricAuthentication()
        case .hintRequested:
            bottomAlertSubject.send(.init(
                title: Strings.Localizable.forgottenPinTitle,
                imageName: .passwordLockDuotone,
                subtitle: AttributedString(Strings.Localizable.forgottenPinDescription),
                actions: [
                    .init(title: Strings.Localizable.commonCancel, kind: .secondary, handler: {}),
                    .init(title: Strings.Localizable.forgottenPinConfirm, kind: .primary, handler: { [weak self] in
                        self?.reset()
                    })
                ]
           ))
        }
    }

    func reset() {
        Modals.pinPadOverlay.dismissAll()
        isLoading = true
        resetAction
            .reset()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion {
                    self?.alert = .genericError()
                }
            })
            .store(in: &disposeBag)
    }

    private func handle(pin: PinCode) {
        if pin.count > 0 && pin.count < maxDigitCount {
            pinError = nil
        }
        if pin.count < maxDigitCount {
            pinState = .editing
        }
        if pin.count == maxDigitCount {
            onPinEntered(pin: pin)
        }
    }

    func onPinEntered(pin: PinCode) {
        fatalError("You must overide this function!")
    }

    func showError(message: AttributedString?) {
        pinError = message
        pinState = .error
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pin = []
        }
    }

    func showGenericError() {
        showError(message: AttributedString(Strings.Localizable.commonGenericErrorRetry))
    }

    private func biometricAuthentication() {
        pinStore
            .read()
            .compactMap { $0 }
            .sink(receiveCompletion: { [weak self, authContext] result in
                if case .failure = result, authContext.biometryAvailability == .biometryLocked {
                    self?.alert = .biometryLockedAlert
                }
            }, receiveValue: { [weak self] pinCode in
                self?.pin = pinCode
            })
            .store(in: &disposeBag)
    }
}
