//
//  ScreenViewModel.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 07. 06..
//

import Combine

class ScreenViewModel<Event> {
    var events = PassthroughSubject<Event, Never>()
    deinit {
        events.send(completion: .finished)
    }
}
