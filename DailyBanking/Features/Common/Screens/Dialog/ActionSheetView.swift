//
//  ActionSheetView.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 13..
//

import SwiftUI
import DesignKit

struct ActionSheetView: View {
    private let model: ActionSheetModel

    init(_ model: ActionSheetModel) {
        self.model = model
    }

    @ObservedObject private var selection = Selection()
    class Selection: ObservableObject {
        var hasSelectedAnyItem = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .xs) {
            Text(model.title)
                .textStyle(.headings5)
                .foregroundColor(.text.tertiary)
            ForEach(model.items) { item in
                CardButton(
                    title: item.title,
                    subtitle: item.subtitle,
                    image: Image.optional(item.iconName),
                    supplementaryImage: nil) {
                        selection.hasSelectedAnyItem = true
                        item.action()
                        self.hide()
                    }
            }
        }
    }

    func show(onDismiss: (() -> Void)? = nil) {
        Modals.bottomSheet.show(
            view: self, name: model.title,
            backgroundColor: .background.primary,
            onClose: {
                if !selection.hasSelectedAnyItem {
                    onDismiss?()
                }
            })
    }

    func hide() {
        Modals.bottomSheet.dismiss(model.title)
    }
}

struct ActionSheetView_Previews: PreviewProvider {
    private static let mockItems = [
        ActionSheetModel.Item(title: "Phone number", subtitle: "+3630 123 4567", iconName: DesignKit.ImageName.phone.rawValue, action: {}),
        ActionSheetModel.Item(title: "Email address", subtitle: "example@mails.com", iconName: DesignKit.ImageName.messageUnread.rawValue, action: {}),
        ActionSheetModel.Item(title: "Tax ID", subtitle: nil, iconName: DesignKit.ImageName.id.rawValue, action: {}),
        ActionSheetModel.Item(title: "More options", subtitle: "Do you want a coffee?", iconName: nil, action: {})
    ]

    static var previews: some View {
        BottomSheetView {
            ActionSheetView(.init(title: "Action sheet title", items: Self.mockItems))
        }
        .padding()
        .background(Color.background.secondary)
    }
}
