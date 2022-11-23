//
//  KycStepStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 12..
//

import Foundation

protocol KycStepStore: Store where State == FaceKom.Step { }

class MemoryKycStepStore: MemoryStore<FaceKom.Step>, KycStepStore {
    init() {
        super.init(state: .undetermined)
    }
}
