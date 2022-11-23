//
//  Alert+UIKit.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 06..
//

import Foundation
import UIKit

extension UIAlertController {
    static func from(alertModel: AlertModel) -> UIAlertController {
        var message: String?
        if let subtitle = alertModel.subtitle {
            message = String(subtitle.characters)
        }
        let alertController = UIAlertController(
            title: alertModel.title,
            message: message,
            preferredStyle: .alert
        )
        for action in alertModel.actions {
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.kind.alertActionStyle,
                handler: { _ in action.handler() }
            )
            alertController.addAction(alertAction)
        }
        return alertController
    }
}

private extension AlertModel.Action.Kind {
    var alertActionStyle: UIAlertAction.Style {
        switch self {
        case .primary:
            return .default
        case .secondary:
            return .default
        case .destructive:
            return .destructive
        }
    }
}
