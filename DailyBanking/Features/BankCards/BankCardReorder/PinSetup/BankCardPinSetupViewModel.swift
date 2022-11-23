//
//  BankCardPinSetupViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 25..
//

import Foundation
import SwiftUI
import Resolver
import Combine

enum BankCardPinSetupState {
    case enterFirstPin
    case confirmPin

    var screenTitle: String {
        return Strings.Localizable.pinSetupScreenTitle
    }

    var title: String {
        switch self {
        case .enterFirstPin:
            return Strings.Localizable.pinSetupScreenSubtitle
        case .confirmPin:
            return Strings.Localizable.pinSetupConfirmScreenSubtitle
        }
    }
}

protocol BankCardPinSetupViewModelProtocol: ObservableObject {

    var isLoading: Bool { get }
    var pinText: String { get set }
    var pinSetupState: BankCardPinSetupState { get set }
    var pinCodeState: PinCodeState { get }
    var pinError: AttributedString? { get }
    var fullScreenResult: ResultModel? { get }
    var textFieldFocused: Bool { get set }

    func handle(event: BankCardPinSetupScreenInput)
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }
}

protocol BankCardPinSetupScreenListener: AnyObject {

    func pinInfoTipsRequested(dismissed: @escaping () -> Void)
    func pinSetupEnded()
    func pinSetupCancelled()
    func reorderCancelled()
}

enum BankCardPinSetupScreenInput {
    case showHint
}

private extension NewPinError {

    var localized: String {
        switch self {
        case .matchingCharacters:
            return Strings.Localizable.pinSetupErrorSameChars
        case .sequencialCharacters:
            return Strings.Localizable.pinSetupErrorSequence
        case .mismatchingRequired:
            return Strings.Localizable.pinSetupErrorMismatching
        case .matchingForbidden:
            return Strings.Localizable.pinChangeErrorEqualsOld
        }
    }
}

class BankCardPinSetupViewModel: BankCardPinSetupViewModelProtocol {

    @Injected var bankCardStore: ReadOnly<BankCard?>
    @Injected var bankCardAction: BankCardAction

    weak var screenListener: BankCardPinSetupScreenListener?

    @Published var firstPin: PinCode?
    @Published var pinText: String = ""

    @Published var pinError: AttributedString?
    @Published var pinCodeState: PinCodeState = .editing

    @Published var pinSetupState: BankCardPinSetupState = .enterFirstPin

    @Published var textFieldFocused: Bool = true

    @Published var isLoading: Bool = false
    @Published var fullScreenResult: ResultModel?

    var bottomAlertSubject = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        bottomAlertSubject.eraseToAnyPublisher()
    }

    private var disposeBag = Set<AnyCancellable>()

    enum NewPinError: Error {
        case matchingCharacters
        case sequencialCharacters
        case mismatchingPins
        case customReason(String)

        var localized: String {
            switch self {
            case .matchingCharacters:
                return Strings.Localizable.pinSetupErrorSameChars
            case .sequencialCharacters:
                return Strings.Localizable.pinSetupErrorSequence
            case .mismatchingPins:
                return Strings.Localizable.pinSetupErrorMismatching
            case .customReason(let reason):
                return reason
            }
        }
    }

    init() {
        $pinText
            .removeDuplicates()
            .sink { [weak self] value in

                let pin = value.compactMap { $0.wholeNumberValue }

                self?.handle(pin: pin)
            }
            .store(in: &disposeBag)
    }

    private func handle(pin: PinCode) {

        guard pinCodeState != .success else { return }

        let maxDigitCount = 4
        if pin.count > 0 && pin.count < maxDigitCount {
            pinError = nil
        }
        if pin.count < maxDigitCount {
            pinCodeState = .editing
        }
        if pin.count == maxDigitCount {
            if let error = pin.validate(requiredToMatch: self.firstPin) {
                pinError = AttributedString(error.localized)
                pinCodeState = .error
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.pinText = ""
                }

            } else {
                pinCodeState = .success
                if let firstPin = firstPin {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.finish(pin: firstPin)
                    }
                } else {
                    firstPin = pin
                    pinSetupState = .confirmPin
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.pinText = ""
                        self.pinCodeState = .editing
                    }
                }
            }
        }
    }

    func finish(pin: PinCode) {

        self.isLoading = true

        self.textFieldFocused = false

        self.bankCardAction.reorderCard(pinCode: pin.stringValue)
            .sink { [weak self] completion in
                self?.isLoading = false
                self?.pinCodeState = .editing

                switch completion {
                case .finished:
                    self?.finished()
                case .failure(let error):
                    switch error {
                    case .secondLevelAuth:
                        self?.pinText = ""
                        self?.firstPin = nil
                        self?.pinSetupState = .enterFirstPin
                        self?.textFieldFocused = true
                    case .action(let error):
                        self?.handleBankCardError(error: error)
                    default:
                        self?.showError(
                            title: Strings.Localizable.bankCardReorderErrorTitle,
                            subtitle: Strings.Localizable.bankCardReorderErrorDescription)
                    }
                }
            }
            .store(in: &disposeBag)
    }

    private func handleBankCardError(error: BankCardReorderError) {

        switch error {
        case .transactionRenewalFailed:
            showError(
                title: Strings.Localizable.bankCardReorderErrorTitle,
                subtitle: Strings.Localizable.bankCardReorderErrorDescription)
        case .transactionDBFailure, .transactionTMLinkFailed:
            finished(showResultScreen: false)
        case .transactionGetPanFailed:
            finished()
        case .transactionSetPinFailed:
            showWarning(
                title: Strings.Localizable.bankCardPinCodeSetFailedTitle,
                subtitle: Strings.Localizable.bankCardPinCodeSetFailedDescription)
        case .transactionTMLinkFailedAndSetPinFailed, .transactionDBFailureAndSetPinFailed:
            showWarning(
                title: Strings.Localizable.bankCardPinCodeSetFailedTitle,
                subtitle: Strings.Localizable.bankCardPinCodeSetFailedDescription, showResultScreen: false)
        }
    }

    private func showError(title: String, subtitle: String) {
        self.bottomAlertSubject.send(.init(
            title: title,
            imageName: .alertSemantic,
            subtitle: subtitle,
            actions: [
                .init(title: Strings.Localizable.commonCancel,
                      kind: .secondary,
                      handler: {
                          self.screenListener?.reorderCancelled() }),
                .init(title: Strings.Localizable.commonStartAgain,
                      handler: { self.screenListener?.pinSetupCancelled() })
            ]
       ))
    }

    private func showWarning(title: String, subtitle: String, showResultScreen: Bool = true) {
        self.bottomAlertSubject.send(.init(
            title: title,
            imageName: .warningSemantic,
            subtitle: subtitle,
            actions: [
                .init(title: Strings.Localizable.commonAllRight,
                      kind: .secondary,
                      handler: {
                          if showResultScreen {
                              self.finished()
                          } else {
                              self.screenListener?.pinSetupEnded()
                          }
                      })
            ]
       ))
    }

    private func finished(showResultScreen: Bool = true) {
        if showResultScreen {
            fullScreenResult = .reorderSucceeded { [weak self] in
                self?.fullScreenResult = nil
                self?.screenListener?.pinSetupEnded()
            }
        } else {
            screenListener?.pinSetupEnded()
        }
    }

    private func finishedWithError() {
        fullScreenResult = .reorderSucceeded { [weak self] in
            self?.fullScreenResult = nil
            self?.screenListener?.pinSetupEnded()
        }
    }

    func handle(event: BankCardPinSetupScreenInput) {

        switch event {
        case .showHint:
            self.screenListener?.pinInfoTipsRequested(dismissed: {
                self.textFieldFocused = true
            })
        }
    }
}
