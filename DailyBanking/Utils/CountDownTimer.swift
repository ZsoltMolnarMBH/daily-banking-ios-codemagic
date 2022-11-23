//
//  CountDownTimer.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 11..
//

import Combine
import Foundation

struct CountDownTimer: Publisher {
    struct TimeRemaining {
        let total: TimeInterval

        var minutes: Int {
            Int(total / 60)
        }

        var seconds: Int {
            Int(total.truncatingRemainder(dividingBy: 60))
        }

        var localized: String {
            String(format: "%02d:%02d", minutes, seconds)
        }

        static var zero: TimeRemaining {
            .init(total: 0)
        }
    }

    typealias Output = TimeRemaining
    typealias Failure = Never

    let duration: TimeInterval

    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        let subscription = CountDownSubscription(duration: duration, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private extension CountDownTimer {
    class CountDownSubscription<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure {
        private var duration: TimeInterval
        private var subscriber: S?
        private var timer: Timer?

        init(duration: TimeInterval, subscriber: S) {
            self.duration = duration
            self.subscriber = subscriber
        }

        func request(_ demand: Subscribers.Demand) {
            let date = Date()
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                let remaining = date.addingTimeInterval(self.duration).timeIntervalSince(Date())
                if remaining <= 0 {
                    _ = self.subscriber?.receive(.zero)
                    self.subscriber?.receive(completion: .finished)
                    self.cancel()
                } else {
                    _ = self.subscriber?.receive(TimeRemaining(total: remaining))
                }
            })
            RunLoop.main.add(timer, forMode: .common)
            self.timer = timer
        }

        func cancel() {
            timer?.invalidate()
        }
    }
}
