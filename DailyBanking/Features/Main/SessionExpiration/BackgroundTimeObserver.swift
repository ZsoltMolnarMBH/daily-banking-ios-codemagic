//
//  BackgroundTimeObserver.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 07..
//

import Foundation
import Combine
import UIKit
import Resolver

class BackgroundTimeObserver {
    @Injected private var store: any TokenStore
    @Injected private var config: SessionConfig

    private var timeStamp = Date().timeIntervalSince1970
    private var disposeBag = Set<AnyCancellable>()

    init() {
        startObservation()
    }

    private func startObservation() {
        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.didEnterBackgroundNotification
        ).sink { [weak self] _ in
            self?.timeStamp = Date().timeIntervalSince1970
        }
        .store(in: &disposeBag)

        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.willEnterForegroundNotification
        ).sink { [weak self] _ in
            self?.checkBackgroundTime()
        }
        .store(in: &disposeBag)
    }

    private func checkBackgroundTime() {
        if timeStamp > Date().timeIntervalSince1970 || timeStamp + config.backgroundExpirationTime < Date().timeIntervalSince1970 {
            store.modify {
                $0 = $0?.expired
            }
        }
    }
}
