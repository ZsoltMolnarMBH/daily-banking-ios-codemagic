//
//  BindingExtension.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 02. 09..
//

import SwiftUI

extension Binding where Value == String {
    func filtered(characterSet: CharacterSet) -> Self {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = String(newValue.filtered(characterSet: characterSet))
            })
    }
}
