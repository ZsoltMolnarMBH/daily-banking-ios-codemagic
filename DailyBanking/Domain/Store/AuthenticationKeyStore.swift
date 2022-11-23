//
//  OtpKeyStore.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import Foundation

protocol AuthenticationKeyStore: Store where State == AuthenticationKey? { }
