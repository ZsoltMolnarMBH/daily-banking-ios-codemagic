//
//  MoneyProcess.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 28..
//

import Foundation

typealias MoneyProcess = Process<Money, Error>

protocol MoneyProcessStore: Store where State == MoneyProcess? { }

class MemoryMoneyProcessStore: MemoryStore<MoneyProcess?>, MoneyProcessStore { }
