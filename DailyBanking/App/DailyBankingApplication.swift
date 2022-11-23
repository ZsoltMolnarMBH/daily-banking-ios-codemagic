//
//  DailyBankingApplication.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 02. 17..
//

import UIKit
import Combine

class DailyBankingApplication: UIApplication, UserTouchActivityProvider {

    private let _touchPubliser = PassthroughSubject<UIEvent, Never>()
    var touchPublisher: AnyPublisher<UIEvent, Never> { _touchPubliser.eraseToAnyPublisher() }

    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouch.Phase.began {
                _touchPubliser.send(event)
            }
        }
    }
}
