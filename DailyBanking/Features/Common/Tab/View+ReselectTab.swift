//
//  View+ReselectTab.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 06. 23..
//

import SwiftUI

extension View {
    @ViewBuilder
    func scrollTo<ID>(_ id: ID?, onReselect tab: Tab) -> some View where ID: Hashable {
        if let id = id {
            ScrollViewReader { proxy in
                self.onReceive(NotificationCenter.default.publisher(for: .reselectTab)) { notification in
                    guard let name = notification.object as? String, name == tab.rawValue else { return }
                    withAnimation(.spring()) { proxy.scrollTo(id, anchor: .top) }
                }
            }
        } else {
            self
        }
    }
}
