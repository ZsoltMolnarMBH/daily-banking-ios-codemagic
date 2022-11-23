//
//  Alert+SwiftUI.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 01..
//

import Combine
import SwiftUI

extension View {
    @ViewBuilder
    func alert(alertModel: Binding<AlertModel?>) -> some View {
        let binding = Binding(
            get: { alertModel.wrappedValue != nil },
            set: { newValue in
                alertModel.wrappedValue = newValue ? alertModel.wrappedValue : nil
            }
        )
        let alert = alertModel.wrappedValue
        self.alert(alert?.title ?? "", isPresented: binding) {
            ForEach(alert?.actions ?? []) { action in
                Button(action.title, action: action.handler)
            }
        } message: {
            if let subtitle = alert?.subtitle {
                Text(subtitle)
            } else {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    func designAlert(_ publisher: AnyPublisher<AlertModel, Never>) -> some View {
        self.onReceive(publisher) { alert in
            Modals.bottomAlert.show(alert: alert)
        }
    }

    @ViewBuilder
    func toast(_ publisher: AnyPublisher<String, Never>, duration: Toast.Duration = .short, overrideUserInterfaceStyle: UIUserInterfaceStyle? = nil) -> some View {
        self.onReceive(publisher) {
            Modals.toast.show(text: $0, duration: duration, overrideUserInterfaceStyle: overrideUserInterfaceStyle)
        }
    }
}
