//
//  PushTokenAdapter.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 09. 15..
//

import FirebaseMessaging
import Combine

class PushTokenAdapter {
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    private var disposeBag = Set<AnyCancellable>()

    init() {
        UNUserNotificationCenter.current().getNotificationSettings { [tokenSubject] settings in
            settings.publisher(for: \.authorizationStatus)
                .sink { _ in
                    Messaging.messaging().token { [] token, error in
                        if error != nil {
                            tokenSubject.send(nil)
                        } else if let token = token {
                            tokenSubject.send(token)
                        }
                    }
                }
                .store(in: &self.disposeBag)
        }
    }

    var token: ReadOnly<String?> {
        return ReadOnly(stateSubject: tokenSubject)
    }
}
