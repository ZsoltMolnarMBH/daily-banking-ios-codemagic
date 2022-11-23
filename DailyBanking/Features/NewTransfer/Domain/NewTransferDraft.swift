//
//  NewTransferDraft.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 25..
//

import Foundation

struct NewTransferDraft {
    var beneficiary: Beneficiary?
    struct Beneficiary {
        let name: String
        let accountNumber: String
    }
    var money: Money?
    var notice: String?
}

protocol NewTransferDraftStore: Store where State == NewTransferDraft { }

class MemoryNewTransferDraftStore: MemoryStore<NewTransferDraft>, NewTransferDraftStore {
    override init(state: NewTransferDraft = .init()) {
        super.init(state: state)
    }
}
