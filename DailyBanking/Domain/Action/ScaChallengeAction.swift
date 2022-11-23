//
//  ScaChallengeAction.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 07. 26..
//

import Foundation
import Resolver
import BankAPI
import Combine
import SwiftUI

protocol ScaChallengeAction {
    func getScaChallengeList() -> AnyPublisher<Never, AnyActionError>
    func approveScaChallenge(id: String) -> AnyPublisher<Never, AnyActionError>
    func declineScaChallenge(id: String) -> AnyPublisher<Never, AnyActionError>
}

class ScaChallengeActionImpl: ScaChallengeAction {

    @Injected private var api: APIProtocol
    @Injected private var scaChallengeStore: ScaChallengeStore
    @Injected private var responseMapperScaChallengeList: Mapper<[ScaChallengeFragment], [ScaChallenge]>

    func getScaChallengeList() -> AnyPublisher<Never, AnyActionError> {
        return api.publisher(for: GetScaChallengeListQuery(), cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap { [responseMapperScaChallengeList] response -> [ScaChallenge] in
                let dto = response.getScaChallengeList.map { $0.fragments.scaChallengeFragment }
                return try responseMapperScaChallengeList.map(dto)
            }
            .map { [scaChallengeStore] scaChallenges in
                scaChallengeStore.modify { $0 = scaChallenges }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func approveScaChallenge(id: String) -> AnyPublisher<Never, AnyActionError> {
        return api.publisher(for: ApproveScaChallengeMutation(scaChallengeId: id))
            .tryMap { [weak self] _ in
                let scaChallenges = self?.scaChallengeStore.state.value.filter { $0.id != id } ?? []
                self?.scaChallengeStore.modify { $0 = scaChallenges }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }

    func declineScaChallenge(id: String) -> AnyPublisher<Never, AnyActionError> {
        return api.publisher(for: DeclineScaChallengeMutation(scaChallengeId: id))
            .tryMap { [weak self] _ in
                let scaChallenges = self?.scaChallengeStore.state.value.filter { $0.id != id } ?? []
                self?.scaChallengeStore.modify { $0 = scaChallenges }
            }
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }
}
