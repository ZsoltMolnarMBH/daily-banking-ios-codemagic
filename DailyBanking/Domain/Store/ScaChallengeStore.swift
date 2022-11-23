//
//  ScaChallengeStore.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 07. 26..
//

import Foundation

protocol ScaChallengeStore {
    var state: ReadOnly<[ScaChallenge]> { get }
    func modify(_ transform: @escaping (inout [ScaChallenge]) -> Void)
}

class MemoryScaChallengeStore: MemoryStore<[ScaChallenge]>, ScaChallengeStore {
    init() {
        super.init(state: [])
    }
}
