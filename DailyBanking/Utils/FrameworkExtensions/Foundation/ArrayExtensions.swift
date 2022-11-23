//
//  ArrayExtensions.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2021. 12. 16..
//

import Foundation

public extension Array {
    func safeAt(_ index: Int) -> Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        return nil
    }
}

public extension Array where Element: Equatable {
    mutating func remove (element: Element) {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        }
    }
}
