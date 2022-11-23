//
//  BankCardInfoScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 25..
//

import Foundation
import Combine
import Resolver

class BankCardInfoScreenViewModel: BankCardInfoScreenViewModelProtocol {
    private var toastSubject = PassthroughSubject<String, Never>()
    private var disposeBag = Set<AnyCancellable>()

    var toast: AnyPublisher<String, Never> {
        toastSubject.eraseToAnyPublisher()
    }
    @Published var timeCounterText: AttributedString = "1:00"
    @Published var name: String = " "
    @Published var cardNumber: String = " "
    @Published var cvc: String = " "
    @Published var valid: String = " "

    var onClose: (() -> Void)?

    @Injected var bankCardInfo: ReadOnly<BankCardInfo?>

    init() {
        bankCardInfo.publisher
            .compactMap { $0 }
            .sink { [weak self] bankCardInfo in
                self?.populate(bankCardInfo: bankCardInfo)
                self?.startTimer()
            }
            .store(in: &disposeBag)
    }

    private func populate(bankCardInfo: BankCardInfo) {
        cardNumber = bankCardInfo.cardNumber.formatted(pattern: .cardNumber)
        cvc = bankCardInfo.cvc
        name = bankCardInfo.name
        valid = bankCardInfo.valid
    }

    private func startTimer() {
        CountDownTimer(duration: 60)
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

    func handle(event: BankCardInfoScreenInput) {
        switch event {
        case .copyBankCardNumber:
            UIPasteboard.general.string = cardNumber.deformatted(pattern: .cardNumber)
            toastSubject.send(Strings.Localizable.bankCardInfoCardNumberCopiedToClipboard)
        case .close:
            onClose?()
        }
    }
}
