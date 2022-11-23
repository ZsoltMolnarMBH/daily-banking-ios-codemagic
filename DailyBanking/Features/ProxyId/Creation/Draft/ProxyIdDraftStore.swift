//
//  ProxyIdDraftStore.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 12..
//

import Foundation

protocol ProxyIdDraftStore: Store where State == ProxyIdDraft { }

class MemoryProxyIdDraftStore: MemoryStore<ProxyIdDraft>, ProxyIdDraftStore {
    init() {
        super.init(state: .init())
    }
}
