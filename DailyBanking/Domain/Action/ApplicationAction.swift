//
//  ApplicationAction.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 22..
//

import Combine
import BankAPI
import Foundation
import Resolver

protocol ApplicationAction {
    func refreshApplication() -> AnyPublisher<Never, AnyActionError>

    func selectProduct(with productID: String) -> AnyPublisher<Never, ActionError<ApplicationActionError>>
    func updateStatements(with statements: AccountOpeningDraft.Statements, kycSurvey: AccountOpeningDraft.KycSurvey) -> AnyPublisher<Never, ActionError<ApplicationActionError>>
    func signContract() -> AnyPublisher<Never, ActionError<ApplicationActionError>>
    func requestContract() -> AnyPublisher<Never, ActionError<ApplicationActionError>>
    func requestAccount() -> AnyPublisher<Never, ActionError<ApplicationActionError>>

    func resendVerificationEmail() -> AnyPublisher<Never, AnyActionError>
    func pollingEmailVerified(delay: TimeInterval) -> AnyPublisher<Never, AnyActionError>
    func changeEmailAddress(email: String) -> AnyPublisher<Never, AnyActionError>
}

enum ApplicationActionError: Error {
    case accountCreationTemporarilyFailed
    case accountCreationBlocked
    case contractCreationFailed
}

class ApplicationActionImpl: ApplicationAction {
    private enum PollingError: Error {
        case dataIsNotReady(pollingDelayMs: Int)
        case stillPending
    }

    @Injected private var api: APIProtocol
    @Injected private var draftStore: any AccountOpeningDraftStore
    @Injected private var individualStore: any IndividualStore
    @Injected private var responseMapper: Mapper<GetApplicationQuery.Data, AccountOpeningDraft>

    func refreshApplication() -> AnyPublisher<Never, AnyActionError> {
        api.publisher(for: GetApplicationQuery(), cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap { [responseMapper] response in
                try responseMapper.map(response)
            }
            .map { [draftStore] draft in
                draftStore.modify {
                    $0.nextStep = draft.nextStep
                    $0.selectedProduct = draft.selectedProduct
                    $0.statements = draft.statements
                    $0.signInfo = draft.signInfo
                    $0.contractID = draft.contractID
                    $0.statements?.dmStatement = draft.statements?.dmStatement
                    if let individual = draft.individual {
                        $0.individual = individual
                    }
                }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func selectProduct(with productID: String) -> AnyPublisher<Never, ActionError<ApplicationActionError>> {
        let input = ApplicationInput(selectedProduct: productID)
        return api.publisher(for: UpdateApplicationMutation(application: input))
            .tryMap { response -> Void in
                if response.updateApplication.status == .ok {
                    return ()
                }
                throw ResponseStatusError.statusFailed
            }
            .handleEvents(receiveCompletion: { [draftStore] _ in
                draftStore.modify {
                    $0.selectedProduct = productID
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: ApplicationActionError.self)
    }

    func updateStatements(with statements: AccountOpeningDraft.Statements, kycSurvey: AccountOpeningDraft.KycSurvey) -> AnyPublisher<Never, ActionError<ApplicationActionError>> {
        let statementsInput = ConsentInfoInput(
            isPep: statements.isPep,
            taxation: statements.taxation.map { .init(country: $0.country, taxNumber: $0.taxNumber) },
            acceptTerms: statements.acceptTerms,
            acceptConditions: statements.acceptConditions,
            acceptPrivacyPolicy: statements.acceptPrivacyPolicy
        )

        let kycSurveyInput = KycSurveyInput(
            incomingSources: .init(salary: kycSurvey.incomingSources?.salary == true, other: kycSurvey.incomingSources?.other),
            depositPlan: .init(
                amountFrom: kycSurvey.depositPlan?.amountFrom,
                amountTo: kycSurvey.depositPlan?.amountTo,
                currency: kycSurvey.depositPlan?.currency),
            transferPlan: .init(
                amountFrom: kycSurvey.transferPlan?.amountFrom,
                amountTo: kycSurvey.transferPlan?.amountTo,
                currency: kycSurvey.transferPlan?.currency)
        )

        return api.publisher(
            for: UpdateApplicationMutation(
                application: .init(
                    consentInfo: statementsInput,
                    kycSurvey: kycSurveyInput,
                    dmStatement: .init(
                        push: statements.dmStatement?.push,
                        email: statements.dmStatement?.email,
                        robinson: statements.dmStatement?.robinson
                    )
                )
            ))
            .tryMap { response -> Void in
                if response.updateApplication.status == .ok {
                    return ()
                }
                throw ResponseStatusError.statusFailed
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: ApplicationActionError.self)
    }

    func signContract() -> AnyPublisher<Never, ActionError<ApplicationActionError>> {
        let signDate = Date()
        let input = SignInfoInput(isSigned: true, signedAt: DateFormatter.simple.string(from: signDate))

        return api.publisher(for: UpdateApplicationMutation(application: .init(signInfo: input)))
            .tryMap { response -> Void in
                if response.updateApplication.status == .ok {
                    return ()
                }
                throw ResponseStatusError.statusFailed
            }
            .handleEvents(receiveCompletion: { [draftStore] _ in
                draftStore.modify {
                    $0.signInfo = .init(signedAt: signDate)
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: ApplicationActionError.self)
    }

    func requestContract() -> AnyPublisher<Never, ActionError<ApplicationActionError>> {
        Just(GetContractInfoQuery())
            .flatMap { [api] query in
                api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .tryMap({ response -> String in
                if let isSuccessful = response.getApplication.contractInfo?.fragments.contractInfoFragment.successful,
                   let contractID = response.getApplication.contractInfo?.fragments.contractInfoFragment.contractId,
                    isSuccessful {
                    return contractID
                }
                if let pollInterval = response.getApplication.contractInfo?.fragments.contractInfoFragment.polling,
                   pollInterval > 0 {
                    throw PollingError.dataIsNotReady(pollingDelayMs: Int(pollInterval))
                }
                throw ApplicationActionError.contractCreationFailed
            })
            .catch({ (error: Error) -> AnyPublisher<String, Error> in
                switch error {
                case PollingError.dataIsNotReady(let delay):
                    return Fail(error: error)
                        .delay(for: .milliseconds(delay), scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                default:
                    return Just("")
                      .setFailureType(to: Error.self)
                      .eraseToAnyPublisher()
                }
            })
            .retry(.max)
            .tryMap({ [draftStore] contractID -> String in
                if contractID.isEmpty {
                    throw ApplicationActionError.contractCreationFailed
                }
                draftStore.modify {
                    $0.contractID = contractID
                }
                return contractID
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: ApplicationActionError.self)
    }

    func requestAccount() -> AnyPublisher<Never, ActionError<ApplicationActionError>> {
        Just(GetAccountInfoQuery())
            .flatMap { [api] query in
                api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            }
            .tryMap({ response -> Result<String, Error> in
                if let isSuccessful = response.getApplication.accountInfo?.fragments.accountInfoFragment.successful,
                   let accountId = response.getApplication.accountInfo?.fragments.accountInfoFragment.accountId,
                    isSuccessful {
                    return .success(accountId)
                }
                if let pollInterval = response.getApplication.accountInfo?.fragments.accountInfoFragment.polling,
                   pollInterval > 0 {
                    throw PollingError.dataIsNotReady(pollingDelayMs: Int(pollInterval))
                }
                if response.getApplication.accountInfo?.fragments.accountInfoFragment.error == "BLOCKED_ERROR" {
                    throw ApplicationActionError.accountCreationBlocked
                } else {
                    throw ApplicationActionError.accountCreationTemporarilyFailed
                }
            })
            .catch({ (error: Error) -> AnyPublisher<Result<String, Error>, Error> in
                switch error {
                case PollingError.dataIsNotReady(let delay):
                    return Fail(error: error)
                        .delay(for: .milliseconds(delay), scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                default:
                    return Just(.failure(error))
                      .setFailureType(to: Error.self)
                      .eraseToAnyPublisher()
                }
            })
            .retry(.max)
            .tryMap({ [draftStore] result -> Void in
                switch result {
                case .success(let accountID):
                    draftStore.modify {
                        $0.accountID = accountID
                    }
                case .failure(let error):
                    throw error
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: ApplicationActionError.self)
    }

    func resendVerificationEmail() -> AnyPublisher<Never, AnyActionError> {
        api.publisher(for: ResendVerificationEmailQuery(), cachePolicy: .fetchIgnoringCacheCompletely)
            .handleEvents(receiveOutput: { [draftStore] response in
                draftStore.modify({
                    $0.emailOperationBlockedUntil = Date().addingTimeInterval(response.getVerificationEmail.nextRequestInterval)
                })
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func pollingEmailVerified(delay: TimeInterval) -> AnyPublisher<Never, AnyActionError> {
        Just(GetEmailVerifiedQuery()).flatMap { [api] in
            api.publisher(
                for: $0,
                cachePolicy: .fetchIgnoringCacheCompletely)
        }.tryMap { response in
            guard let isVerified = response.getIndividual.mainEmail.verified, isVerified else {
                throw PollingError.stillPending
            }

            return isVerified
        }.retry(times: .max, delay: delay) { error in
            if let pollingError = error as? PollingError {
                if case .stillPending = pollingError {
                    return true
                }
            }
            return false
        }.handleEvents(receiveOutput: { [individualStore] isEmailVerified in
            individualStore.modify {
                $0?.email.isVerified = isEmailVerified
            }
        })
        .ignoreOutput()
        .eraseToAnyPublisher()
        .mapAnyActionError()
    }

    func changeEmailAddress(email: String) -> AnyPublisher<Never, AnyActionError> {
        api.publisher(for: ChangeEmailMutation(email: email))
            .handleEvents(receiveOutput: { [individualStore, draftStore] result in
                draftStore.modify {
                    $0.emailOperationBlockedUntil = Date().addingTimeInterval(result.changeEmail.nextRequestInterval)
                    $0.individual?.email.address = email
                }
                individualStore.modify {
                    $0?.email.address = email
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }
}
