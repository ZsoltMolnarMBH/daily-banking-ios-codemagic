//
//  BankCardReorderViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 24..
//

import Foundation
import Resolver
import Combine

protocol BankCardReorderScreenListener: AnyObject {
    func pinSetupRequested()
    func addressInfoRequested()
}

class BankCardReorderViewModel: BankCardReorderViewModelProtocol {

    @Injected private var individualObject: ReadOnly<Individual?>

    @Published var isLoading: Bool = false

    weak var screenListener: BankCardReorderScreenListener?

    private var disposeBag = Set<AnyCancellable>()

    @Published var address: String = ""

    var deliveryDate: String {

        let today = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 5
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: today) ?? today

        return DateFormatter.userFacing.string(from: futureDate)
    }

    var currency: String {
        return MoneyViewModel.make(using: Money.zeroHUF).currency.symbol
    }
    init() {
        isLoading = individualObject.value == nil
        individualObject.publisher
            .compactMap { $0 }
            .sink { [weak self] individual in

                self?.address = individual?.legalAddress?.streetName ?? ""
            }
            .store(in: &disposeBag)
    }

    func handle(_ event: BankCardReorderScreenInput) {
        switch event {
        case .order:
            screenListener?.pinSetupRequested()
        case .addressInfo:
            screenListener?.addressInfoRequested()
        }
    }
}
