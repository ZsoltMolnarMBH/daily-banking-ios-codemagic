//
//  NewTransferSummaryScreenViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 27..
//

import Foundation
import Resolver
import Combine
import Apollo

enum NewTransferSummaryScreenResult {
    case transferFinished(NewTransferResult)
    case transferDateInfoRequested
}

class NewTransferSummaryScreenViewModel: ScreenViewModel<NewTransferSummaryScreenResult>, NewTransferSummaryScreenViewModelProtocol {
    @Injected private var action: NewTransferAction
    @Injected private var draft: ReadOnly<NewTransferDraft>
    @Injected(name: .newTransfer.fee) private var transactionFee: ReadOnly<MoneyProcess?>
    private var disposeBag = Set<AnyCancellable>()

    @Published var details: TransferDetailsViewModel = .init(beneficiaryName: "",
                                                             accountNumber: "",
                                                             money: "",
                                                             notice: "",
                                                             transferDate: "",
                                                             transferType: "")
    @Published var sendLabel = ""
    var sendHint = Strings.Localizable.newTransferSummaryTransferBottomHint
    @Published var isLoading: Bool = false
    @Published var isSendEnabled: Bool = true
    var alert: AnyPublisher<AlertModel, Never> {
        alertSubject.eraseToAnyPublisher()
    }
    private let alertSubject = PassthroughSubject<AlertModel, Never>()

    private let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    override init() {
        super.init()
        Publishers.CombineLatest(draft.publisher, transactionFee.publisher)
            .map { [dateFormatter] draft, fee -> TransferDetailsViewModel in
                let localizedMoney = draft.money!.localizedString
                let accountNumber = draft.beneficiary!.accountNumber
                return .init(beneficiaryName: draft.beneficiary?.name ?? "",
                             accountNumber: accountNumber.formatted(pattern: .accountNumber),
                             money: localizedMoney,
                             fee: fee?.localizedTransactionFee,
                             notice: draft.notice,
                             transferDate: dateFormatter.string(from: Date()),
                             transferType: Strings.Localizable.newTransferSummaryInstantTransfer)
            }
            .assign(to: &$details)
        transactionFee.publisher
            .map { !($0?.isLoading ?? false) }
            .assign(to: &$isSendEnabled)
        let localizedMoney = draft.value.money!.localizedString
        sendLabel = Strings.Localizable.newTransferSummarySend(localizedMoney)
    }

    func handle(event: NewTransferSummaryScreenInput) {
        switch event {
        case .confirm:
            performTransfer()
        case .trasnferDateInfo:
            events.send(.transferDateInfoRequested)
        }
    }

    func performTransfer() {
        isLoading = true
        action.initiateNewTransfer()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case .unknown:
                        self?.events.send(.transferFinished(.failure(.unknown)))
                    case .network(let error):
                        self?.onCommunicationError(error: error)
                    case .secondLevelAuth:
                        break
                    case .action(let error):
                        self?.events.send(.transferFinished(.failure(error)))
                    }
                }
            } receiveValue: { [weak self] success in
                self?.events.send(.transferFinished(.success(success)))
            }
            .store(in: &disposeBag)
    }

    private func onCommunicationError(error: CommunicationError) {
        alertSubject.send(.networkError())
    }
}
