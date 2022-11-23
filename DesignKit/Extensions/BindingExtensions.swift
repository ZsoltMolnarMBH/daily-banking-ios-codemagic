//
//  BindingExtensions.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 22..
//

import SwiftUI

public extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
