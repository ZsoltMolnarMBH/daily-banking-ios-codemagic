//
//  EmailClientChecker.swift
//  DailyBanking
//
//  Created by ALi on 2022. 04. 26..
//

import Foundation
import UIKit

protocol EmailClientManaging {
    var availableMailClients: [EmailClient] { get }

    func launchEmailClient(_ emailClient: EmailClient)
}

enum EmailClient: String, CaseIterable {
    case native = "message://"
    case gmail = "googlegmail://"
    case outlook = "ms-outlook://"
    case spark = "readdle-spark://"

    var urlScheme: String {
        rawValue
    }
}

class EmailClientManager: EmailClientManaging {

    lazy var availableMailClients: [EmailClient] = {
        EmailClient.allCases.compactMap { emailClient in
            guard let url = URL(string: emailClient.urlScheme) else {
                return nil
            }

            return UIApplication.shared.canOpenURL(url) ? emailClient : nil
        }
    }()

    func launchEmailClient(_ emailClient: EmailClient) {
        guard let url = URL(string: emailClient.urlScheme) else {
            return
        }

        UIApplication.shared.open(url)
    }
}
