//
//  KycDraftStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 22..
//

import Foundation

protocol KycDraftStore: Store where State == KycDraft { }

class MemoryKycDraftStore: MemoryStore<KycDraft>, KycDraftStore {
    init() {
        super.init(state: KycDraft())
    }
}
