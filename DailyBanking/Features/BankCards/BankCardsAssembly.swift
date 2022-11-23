//
//  CardsAssembly.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import BankAPI
import Foundation
import Resolver
import Apollo

extension Resolver.Name {
    struct Card {}
    static let card = Card()
}

class BankCardsAssembly: Assembly {
    func assemble(container: Resolver) {
        container.registerInContext {
            BankCardScreenViewModel()
        }

        container.registerInContext {
            BankCardBlockViewModel()
        }

        container.registerInContext {
            BankCardReorderViewModel()
        }

        container.registerInContext {
            BankCardPinSetupViewModel()
        }

        container.registerInContext {
            BankCardInfoScreenViewModel()
        }

        container.registerInContext {
            PinCodeRevealScreenViewModel()
        }

        container.registerInContext {
            BankCardLimitStartPageScreenViewModel()
        }

        container.registerInContext {
            BankCardCreditCardLimitScreenViewModel()
        }

        container.registerInContext {
            BankCardCashWithdrawalLimitScreenViewModel()
        }

        container.registerInContext(BankCardScreen<BankCardScreenViewModel>.self) { container in
            BankCardScreen(viewModel: container.resolve())
        }

        container.registerInContext(BankCardBlockScreen<BankCardBlockViewModel>.self) { container in
            BankCardBlockScreen(viewModel: container.resolve())
        }

        container.registerInContext(BankCardReorderScreen<BankCardReorderViewModel>.self) { container in
            BankCardReorderScreen(viewModel: container.resolve())
        }

        container.registerInContext(BankCardPinSetupScreen<BankCardPinSetupViewModel>.self) { container in
            BankCardPinSetupScreen(viewModel: container.resolve())
        }

        container.registerInContext(BankCardLimitStartPageScreen<BankCardLimitStartPageScreenViewModel>.self) { container in
            BankCardLimitStartPageScreen(viewModel: container.resolve())
        }

        container.registerInContext(BankCardInfoScreen<BankCardInfoScreenViewModel>.self) { container in
            BankCardInfoScreen(viewModel: container.resolve())
        }

        container.registerInContext(PinCodeRevealScreen<PinCodeRevealScreenViewModel>.self) { container in
            PinCodeRevealScreen(viewModel: container.resolve())
        }

        container.registerInContext(BankCardCreditCardLimitScreen<BankCardCreditCardLimitScreenViewModel>.self) { container in
            BankCardCreditCardLimitScreen(viewModel: container.resolve())
        }

        container.registerInContext(BankCardCashWithdrawalLimitScreen<BankCardCashWithdrawalLimitScreenViewModel>.self) { container in
            BankCardCashWithdrawalLimitScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            return MemoryBankCardStore(card: nil)
        }
        .implements((any BankCardStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<BankCard?>.self) {
            return container.resolve((any BankCardStore).self).state
        }

        container.registerInContext {
            return MemoryBankCardInfoStore(card: nil)
        }
        .implements((any BankCardInfoStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<BankCardInfo?>.self) {
            return container.resolve((any BankCardInfoStore).self).state
        }

        container.registerInContext {
            return MemoryBankCardPinStore(pin: nil)
        }
        .implements((any BankCardPinStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<String?>.self, name: .card.pin) {
            return container.resolve((any BankCardPinStore).self).state
        }

        container.registerInContext {
            BankCardActionImpl()
        }.implements(BankCardAction.self)

        container.registerInContext(Mapper<(currency: String, data: CardLimitFragment), BankCard.Limit>.self) {
            LimitMapper()
        }

        container.registerInContext(Mapper<(data: CardsGetQuery.Data, currency: String), [BankCard]>.self) {
            BankCardMapper()
        }

        container.registerInContext(Mapper<
                           (data: ChangeCardLimitMutation.Data, currency: String),
                           (cash: BankCard.Limit, pos: BankCard.Limit, vpos: BankCard.Limit)>.self) {
            ChangeCardLimitMapper()
        }

        container.registerInContext(Mapper<(data: CardDetailsQuery.Data.CardDetail, key: [UInt8]), BankCardInfo>.self) {
            BankCardInfoMapper()
        }

        container.registerInContext(Mapper<(data: CardPinQuery.Data, key: [UInt8]), String?>.self) {
            BankCardPinMapper()
        }
    }
}
