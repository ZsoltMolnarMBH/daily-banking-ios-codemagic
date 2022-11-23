//
//  AlertModel.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 01..
//

import Foundation

/// Describes the content of an alert with actions.
/// Primarily to be exposed by ViewModels for Views, so they can show an alert using their preferd method.
struct AlertModel: Equatable {
    let uuid: String = UUID().uuidString
    let title: String?
    let imageName: ImageName?
    let subtitle: AttributedString?
    let actions: [Action]

    init(title: String? = nil, imageName: ImageName? = nil, subtitle: String, actions: [Action]) {
        self.init(title: title,
                  imageName: imageName,
                  subtitle: AttributedString(subtitle),
                  actions: actions)
    }

    init(title: String? = nil, imageName: ImageName? = nil, subtitle: AttributedString? = nil, actions: [Action]) {
        self.title = title
        self.imageName = imageName
        self.subtitle = subtitle
        self.actions = actions
    }

    struct Action: Equatable, Identifiable {
        enum Kind {
            case primary
            case secondary
            case destructive
        }

        let id = UUID()
        let title: String
        let kind: Kind
        let handler: () -> Void

        init(title: String, kind: Kind = .primary, handler: @escaping () -> Void) {
            self.title = title
            self.kind = kind
            self.handler = handler
        }

        static func == (lhs: Action, rhs: Action) -> Bool {
            return lhs.id == rhs.id
        }
    }
}
