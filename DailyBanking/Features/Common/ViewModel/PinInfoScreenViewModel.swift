//
//  PinCreationInfoScreenViewModel.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 11. 09..
//

import Foundation

enum PinInfoScreenEvent {
    case proceed
    case hintRequested
}

class PinInfoScreenViewModel: ScreenViewModel<PinInfoScreenEvent>,
                              PinInfoScreenViewModelProtocol {
    func handle(input: PinInfoScreenInput) {
        switch input {
        case .hint:
            events.send(.hintRequested)
        case .proceed:
            events.send(.proceed)
        }
    }
}
