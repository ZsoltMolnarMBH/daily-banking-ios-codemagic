//
//  ActionSheet+SwiftUI.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 19..
//

import Combine
import SwiftUI

extension View {
    @ViewBuilder
    func actionSheet(_ publisher: AnyPublisher<ActionSheetModel, Never>) -> some View {
        self.onReceive(publisher) { model in
            ActionSheetView(model).show()
        }
    }
}
