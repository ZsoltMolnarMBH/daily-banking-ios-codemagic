//
//  PinCodeRevealScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 26..
//

import Foundation
import Combine
import Resolver

class PinCodeRevealScreenViewModel: PinCodeRevealScreenViewModelProtocol {
    private var timeCounter = 10
    private var disposeBag = Set<AnyCancellable>()

    var onClose: (() -> Void)?

    @Published var timeCounterText: AttributedString = "10"
    @Published var pinCode: String = " "

    @Injected(name: .card.pin) var bankCardPinStore: ReadOnly<String?>

    init() {
        bankCardPinStore.publisher
            .compactMap { $0 }
            .sink { [weak self] pin in
                self?.pinCode = pin
                self?.startTimer()
            }
            .store(in: &disposeBag)
    }

    func handle(event: PinCodeRevealScreenInput) {
        switch event {
        case .close:
            onClose?()
        }
    }

    private func startTimer() {
        CountDownTimer(duration: 10)
            .compactMap { timeRemaining in
                try? AttributedString(
                    markdown: Strings.Localizable.bankCardDialogDisappearsWithinSecondsIos(timeRemaining.localized)
                )
            }
            .sink(receiveCompletion: { [weak self] _ in
                self?.onClose?()
            }, receiveValue: { [weak self] text in
                self?.timeCounterText = text
            })
            .store(in: &disposeBag)
    }
}
