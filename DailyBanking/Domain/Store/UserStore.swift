//
//  UserStore.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 03..
//

import Foundation

protocol UserStore: Store where State == User? { }
