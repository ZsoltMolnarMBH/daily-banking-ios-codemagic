//
//  CommonModifiers.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 29..
//

import SwiftUI

public extension View {
    @ViewBuilder
    func onAppear(after timeInterval: TimeInterval, action: @escaping () -> Void) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                action()
            }
        }
    }

    @ViewBuilder
    func hideContentBackground() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollContentBackground(.hidden)
        } else {
            self
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }     
}
