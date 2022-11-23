//
//  AccountLimitStartPageScreenViewModel.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 02. 21..
//

import Foundation
import AnyFormatKit
import Resolver
import Combine

enum AccountLimitStartPageScreenResult {
    case limitScreenRequested
    case limitInfoScreenRequested
}

class AccountLimitStartPageScreenViewModel: ScreenViewModel<AccountLimitStartPageScreenResult>,
                                            AccountLimitStartPageScreenViewModelProtocol {

    @Injected private var account: ReadOnly<Account?>

    var currencyFormatter = SumTextFormatter(textPattern: "# ###,#")
    private var disposeBag = Set<AnyCancellable>()

    @Published var dailyTransferLimitFormatted: String = ""

    override init() {
        super.init()
        account.publisher
            .sink { [weak self] _ in
                self?.populate()
            }
            .store(in: &disposeBag)
    }

    private func populate() {
        guard let account = account.value else { return }
        dailyTransferLimitFormatted = currencyFormatter.format(String(account.limits.dailyTransferLimit.value)) ?? "0"
    }

    func handle(event: AccountLimitStartPageScreenInput) {
        switch event {
        case .dailyTransferLimit:
            events.send(.limitScreenRequested)
        case .info:
            events.send(.limitInfoScreenRequested)
        }
    }
}
