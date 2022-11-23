//
//  AccountClosingAction.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 31..
//

import Foundation
import Combine
import BankAPI
import Resolver

protocol AccountClosingAction {
    func createAccountClosureStatement(accountId: String, pollingInterval: TimeInterval) -> AnyPublisher<Never, ActionError<AccountClosingError>>
    func closeAccount(accountId: String) -> AnyPublisher<Never, ActionError<AccountClosingError>>
}

enum AccountClosingError: Error {
    case pollingError(_ errorMessage: String)
    case invalidArgument
}

class AccountClosingActionImpl: AccountClosingAction {

    @Injected private var api: APIProtocol
    @Injected private var accountClosingDraftStore: any AccountClosingDraftStore
    @Injected private var accountStore: any AccountStore
    @Injected private var mapper: Mapper<AccountFragment, Account>

    enum PollingError: Error {
        case pollingStillPending
    }

    func createAccountClosureStatement(accountId: String, pollingInterval: TimeInterval = 3.0) -> AnyPublisher<Never, ActionError<AccountClosingError>> {
        api.publisher(
            for: CreateAccountClosureStatementMutation(input: .init(accountId: accountId))
        ).tryMap { response in
            guard response.createAccountClosureStatement.status == .ok else {
                throw ResponseStatusError.statusFailed
            }
        }.flatMap { [api] _ -> AnyPublisher<String, Error> in
            Just(GetAccountClosureStatementQuery(accountId: accountId)).flatMap { [api] in
                api.publisher(for: $0, cachePolicy: .fetchIgnoringCacheData)
            }.tryMap { response in
                let fragment = response.getAccountClosureStatement.contractInfo.fragments.accountClosureStatementInfoFragment

                if let errorMessage = fragment.error {
                    throw AccountClosingError.pollingError(errorMessage)
                }
                if let contractId = fragment.contractId {
                    return contractId
                }

                throw PollingError.pollingStillPending
            }.retry(times: .max, delay: pollingInterval) { error in
                if case PollingError.pollingStillPending = error {
                    return true
                }
                return false
            }
        }.handleEvents(receiveOutput: { [accountClosingDraftStore] contractId in
            accountClosingDraftStore.modify { draft in
                draft.withdrawalStatementContractId = contractId
            }
        })
        .ignoreOutput()
        .eraseToAnyPublisher()
        .mapActionError(to: AccountClosingError.self)
    }

    func closeAccount(accountId: String) -> AnyPublisher<Never, ActionError<AccountClosingError>> {
        guard let transferAccount = accountClosingDraftStore.state.value.transferAccount, !transferAccount.isEmpty else {
            return Fail(error: AccountClosingError.invalidArgument)
                .mapActionError(to: AccountClosingError.self)
                .eraseToAnyPublisher()
        }

        let input = CloseAccountInput(
            accountId: accountId,
            disbursementAccountNumber: transferAccount,
            feedback: .init(
                reason: accountClosingDraftStore.state.value.reason,
                comment: accountClosingDraftStore.state.value.comment
            )
        )

        return api.publisher(
            for: CloseAccountMutation(input: input)
        ).tryMap { [mapper, accountStore] response in
            let updatedAccount = try mapper.map(response.closeAccount.fragments.accountFragment)
            accountStore.modify { account in
                account = updatedAccount
            }
        }
        .ignoreOutput()
        .eraseToAnyPublisher()
        .mapActionError(to: AccountClosingError.self)
    }
}

extension ClosureFeedbackInput {
    init?(reason: AccountClosingDraft.Reason?, comment: String?) {
        if reason == nil, comment == nil {
            return nil
        }

        self.init(code: .init(from: reason), comment: comment)
    }
}

extension ClosureFeedbackCode {
    init?(from reason: AccountClosingDraft.Reason?) {
        guard let reason = reason else {
            return nil
        }

        switch reason {
        case .tooExpensive:
            self = .tooExpensive
        case .dissatisfied:
            self = .dissatisfied
        case .foundBetter:
            self = .betterAlternaitve
        case .badSupport:
            self = .poorSupport
        }
    }
}
