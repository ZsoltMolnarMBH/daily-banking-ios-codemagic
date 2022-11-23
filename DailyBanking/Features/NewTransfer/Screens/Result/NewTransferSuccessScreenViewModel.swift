//
//  NewTransferSuccessScreenViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 28..
//

import Combine
import Foundation

enum NewTransferSuccessScreenResult {
    case acknowledge
}

class NewTransferSuccessScreenViewModel: ScreenViewModel<NewTransferSuccessScreenResult>, NewTransferSuccessScreenViewModelProtocol {
    private var transaction: CurrentValueSubject<PaymentTransaction, Error>
    @Published var title = ""
    @Published var subtitle = ""
    @Published var details = TransferDetailsViewModel(beneficiaryName: "",
                                                      accountNumber: "",
                                                      money: "",
                                                      notice: "",
                                                      transferDate: "",
                                                      transferType: "")
    private var disposeBag = Set<AnyCancellable>()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    init(transaction: PaymentTransaction) {
        self.transaction = .init(transaction)
        super.init()
        self.transaction
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] transaction in
                guard let self = self else { return }
                switch transaction.state {
                case .pending:
                    self.title = Strings.Localizable.newTransferStatePendingTitle
                    self.subtitle = Strings.Localizable.newTransferStatePendingDescription
                case .completed:
                    self.title = Strings.Localizable.newTransferStateCompleteTitle
                    self.subtitle = Strings.Localizable.newTransferStateCompleteDescription
                case .rejected:
                    return
                }
                self.details = .init(beneficiaryName: transaction.name,
                                     accountNumber: transaction.accountNumber.formatted(pattern: .accountNumber),
                                     money: transaction.amount.localizedString,
                                     fee: transaction.fee?.localizedTransactionFee,
                                     notice: transaction.reference,
                                     transferDate: self.dateFormatter.string(from: transaction.createdAt),
                                     transferType: Strings.Localizable.newTransferSummaryInstantTransfer)
            })
            .store(in: &disposeBag)
    }

    func handle(event: NewTransferSuccessScreenInput) {
        switch event {
        case .acknowledge:
            events.send(.acknowledge)
        }
    }
}
