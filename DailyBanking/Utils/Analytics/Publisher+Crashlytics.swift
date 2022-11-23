//
//  Publisher+Crashlytics.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 18..
//

import Firebase
import Foundation
import Combine

extension Publisher {
    func sendCrashlyticsError() -> AnyPublisher<Output, Failure> {
        return self.handleEvents(receiveCompletion: { event in
            switch event {
            case .finished:
                break
            case .failure(let error):
                Crashlytics.crashlytics().record(error: error)
            }
        }).eraseToAnyPublisher()
    }
}
