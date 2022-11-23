//
//  BasePinCreationViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 16..
//

import Combine
import LocalAuthentication

enum PinCreationScreenEvent {
    case finishedPinCreation(PinCode)
    case pinCreationTipsRequested
}

class BasePinCreationScreenViewModel: ScreenViewModel<PinCreationScreenEvent>,
                                      PinPadScreenViewModelProtocol {
    @Published var analyticsName: String = ""

    var title: String {
        if firstPin == nil {
            return Strings.Localizable.pinCreationHeaderAddIos(maxDigitCount)
        } else {
            return Strings.Localizable.pinCreationHeaderConfirm
        }
    }

    let maxDigitCount: Int = 6
    let supportedBiometryType: LABiometryType = .none

    @Published var pin: PinCode = []
    @Published var pinError: AttributedString?
    @Published var isLoading = false
    @Published var pinState: PinState = .editing
    @Published var alert: AlertModel?
    @Published var hint: String?

    private var _bottomAlert = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        _bottomAlert.eraseToAnyPublisher()
    }

    func handle(input: PinPadScreenInput) {
        switch input {
        case .biometricAuthRequested:
            break
        case .hintRequested:
            events.send(.pinCreationTipsRequested)
        }
    }

    // MARK: Internals

    @Published var firstPin: PinCode?
    var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        $pin
            .removeDuplicates()
            .sink { [weak self] in
                self?.pin = $0
                self?.handle(pin: $0)
            }
            .store(in: &disposeBag)

        $firstPin
            .removeDuplicates()
            .map { $0 == nil ? Strings.Localizable.pinInfoHint : "" }
            .assign(to: &$hint)
    }

    private func handle(pin: PinCode) {
        if pin.count > 0 && pin.count < maxDigitCount {
            pinError = nil
        }
        if pin.count < maxDigitCount {
            pinState = .editing
        }
        if pin.count == maxDigitCount {
            if let error = validate(firstPin: self.firstPin) {
                pinError = AttributedString(error.localized)
                pinState = .error
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.pin = []
                }

            } else {
                pinState = .success
                if let firstPin = firstPin {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.finish(pin: firstPin)
                    }
                } else {
                    firstPin = pin
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.pin = []
                    }
                }
            }
        }
    }

    func finish(pin: PinCode) {
        fatalError("Must override this function!")
    }

    func validate(firstPin: PinCode?) -> NewPinError? {
        return self.pin.validate(requiredToMatch: firstPin)
    }
}

private extension NewPinError {
    var localized: String {
        switch self {
        case .matchingCharacters:
            return Strings.Localizable.pinCreationErrorSameChars
        case .sequencialCharacters:
            return Strings.Localizable.pinCreationErrorSequence
        case .mismatchingRequired:
            return Strings.Localizable.pinCreationErrorMismatching
        case .matchingForbidden:
            return Strings.Localizable.pinChangeErrorEqualsOld
        }
    }
}
