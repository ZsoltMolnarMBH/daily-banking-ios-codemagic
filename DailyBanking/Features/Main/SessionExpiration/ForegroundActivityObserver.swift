//
//  ForegroundActivityObserver.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 17..
//

import Combine
import Foundation
import UIKit
import Resolver

protocol UserTouchActivityProvider {
    var touchPublisher: AnyPublisher<UIEvent, Never> { get }
}

class ForegroundActivityObserver {
    @Injected private var provider: UserTouchActivityProvider
    @Injected private var tokenStore: any TokenStore
    @Injected private var config: SessionConfig

    private var isWarning: Bool = false
    private var timer: AnyCancellable?
    private var disposeBag = Set<AnyCancellable>()

    var onForegroundActivityWarning: ((@escaping () -> Void) -> Void)?

    init() {
        provider.touchPublisher
            .sink { [weak self] _ in
                self?.onTouch()
            }
            .store(in: &disposeBag)

        tokenStore.state.publisher
            .compactMap { $0?.foregroundSessionExpired }
            .removeDuplicates()
            .sink { [weak self] isExpired in
                if isExpired {
                    self?.stopTimer()
                } else {
                    self?.startTimer()
                }
            }
            .store(in: &disposeBag)

        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.didEnterBackgroundNotification
        ).sink { [weak self] _ in
            self?.isWarning = false
            self?.stopTimer()
        }
        .store(in: &disposeBag)

        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.willEnterForegroundNotification
        ).sink { [weak self] _ in
            self?.onTouch()
        }
        .store(in: &disposeBag)
    }

    private func onTouch() {
        guard tokenStore.state.value?.foregroundSessionExpired == false else { return }
        if isWarning == false {
            startTimer()
        }
    }

    private func stopTimer() {
        timer?.cancel()
    }

    private func startTimer() {
        let warningInterval = config.foregroundInactivityWarningTime
        let expirationInterval = config.foregroundInactivityExpirationTime
        let timerStartedAt = Date()
        timer = Timer.publish(every: 1, tolerance: 0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] date in
                if date.timeIntervalSince(timerStartedAt) >= expirationInterval {
                    self?.tokenStore.modify {
                        $0 = $0?.expired
                    }
                } else if date.timeIntervalSince(timerStartedAt) >= warningInterval {
                    self?.showWarning()
                }
            })
    }

    private func showWarning() {
        guard !isWarning else { return }
        isWarning = true
        onForegroundActivityWarning? { [weak self] in
            self?.isWarning = false
            self?.onTouch()
        }
    }
}
