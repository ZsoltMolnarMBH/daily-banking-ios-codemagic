//
//  PinVerification.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 19..
//

import Combine

protocol PinVerificationDisplay: AnyObject {
    func showPinVerification(
        renewSession: Bool,
        title: String,
        screenName: String,
        then handler: @escaping (PinCode?) -> Void
    )
}

class PinVerification {
    enum Method {
        case verify
        case renewSession
    }

    enum Error: Swift.Error {
        case cancelled
    }

    weak var display: PinVerificationDisplay?
    private var verification: AnyPublisher<PinCode, Swift.Error>?

    func verifyPin(
        method: Method = .verify,
        title: String = Strings.Localizable.loginPinScreenTitle,
        screenName: String = ""
    ) -> AnyPublisher<PinCode, Swift.Error> {
        if let verification = verification {
            return verification
        }

        return Future<PinCode?, Swift.Error> { [weak self] promise in
            self?.display?.showPinVerification(
                renewSession: method == .renewSession,
                title: title,
                screenName: screenName) { pinCode in
                    if let pinCode = pinCode {
                        promise(.success(pinCode))
                    } else {
                        promise(.failure(Error.cancelled))
                    }
                }
        }
        .handleEvents(receiveCompletion: { [weak self] _ in
            self?.verification = nil
        }, receiveCancel: { [weak self] in
            self?.verification = nil
        })
        .compactMap { $0 }
        .share()
        .eraseToAnyPublisher()
    }
}
