//
//  AccountListAction.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 22..
//

import Combine
import BankAPI
import Foundation
import Resolver

protocol AccountAction {
    func refreshAccounts() -> AnyPublisher<Never, AnyActionError>
    func addProxyId(to account: Account, alias: String) -> AnyPublisher<Never, AnyActionError>
    func deleteProxyId(from account: Account, alias: String) -> AnyPublisher<Never, AnyActionError>
    func setLimit(on account: Account, limitValue: Int, limitName: AccountLimits.Limit.Name) -> AnyPublisher<Never, AnyActionError>
}

class AccountActionImpl: AccountAction {
    @Injected private var api: APIProtocol
    @Injected private var accountStore: any AccountStore
    @Injected private var mapper: Mapper<AccountFragment, Account>

    private var refreshingAccounts: AnyPublisher<Never, AnyActionError>?

    func refreshAccounts() -> AnyPublisher<Never, AnyActionError> {
        if let refreshingAccounts = refreshingAccounts {
            return refreshingAccounts
        }

        let refresh = api
            .publisher(for: AccountListQuery(), cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap { [mapper] response -> Account? in
                guard let fragment = response.accountsList.first?.fragments.accountFragment else { return nil }
                return try mapper.map(fragment)
            }
            .map { [accountStore] account in
                accountStore.modify { $0 = account }
            }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.refreshingAccounts = nil
            }, receiveCancel: { [weak self] in
                self?.refreshingAccounts = nil
            })
            .ignoreOutput()
            .share()
            .eraseToAnyPublisher()
            .mapAnyActionError()

        refreshingAccounts = refresh
        return refresh
    }

    func addProxyId(to account: Account, alias: String) -> AnyPublisher<Never, AnyActionError> {
        api.publisher(for: ProxyIdCreateMutation(alias: alias, bic: account.swift, iban: account.iban))
            .tryMap { response in
                guard response.proxyIdCreate.status == .ok else { throw ResponseStatusError.statusFailed }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func deleteProxyId(from account: Account, alias: String) -> AnyPublisher<Never, AnyActionError> {
        api.publisher(for: ProxyIdDeleteMutation(iban: account.iban, bic: account.swift, alias: alias))
            .tryMap { response in
                guard response.proxyIdDelete.status == .ok else { throw ResponseStatusError.statusFailed }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func setLimit(on account: Account, limitValue: Int, limitName: AccountLimits.Limit.Name) -> AnyPublisher<Never, AnyActionError> {
        api.publisher(
            for: SetLimitMutation(
                accountId: account.accountId,
                limitName: AccountListMapper.convertLimitName(from: limitName),
                limitValue: limitValue)
            )
            .tryMap { [mapper] response in
                let fragment = response.setLimit.fragments.accountFragment
                return try mapper.map(fragment)
            }
            .map { [accountStore] account in
                accountStore.modify {
                    $0 = account
                }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }
}
