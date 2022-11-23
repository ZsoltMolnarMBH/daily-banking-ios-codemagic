//
//  SecondLevelAuthentication.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 04..
//

import Combine

protocol SecondLevelAuthenticationDisplay: AnyObject {
    var publisher: AnyPublisher<SecondLevelAuthentication.Event, Never> { get }
    var eventHandler: PassthroughSubject<Result<Void, PinVerificationError>, Never> { get }
}

// SingleInstance
class SecondLevelAuthentication {
    enum Event {
        case cancel
        case otpCreated(String)
    }

    weak var display: SecondLevelAuthenticationDisplay?
}
