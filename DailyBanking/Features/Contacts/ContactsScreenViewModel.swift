//
//  HelpContactsActionSheetViewModel.swift
//  DailyBanking
//
//  Created by Alexa Mark on 2021. 12. 13..
//

import Foundation
import UIKit

protocol ContactsScreenViewModelProtocol: ObservableObject {
    var email: String { get }

    func handle(event: ContactsScreenInput)
}

protocol ContactsScreenListener: AnyObject {
    func contactInfoScreenRequested()
    func feedbackRequested()
}

enum ContactsScreenInput: String {
    case emailPressed
    case contactInfoPressed
    case sendFeedback
}

class ContactsScreenViewModel: ContactsScreenViewModelProtocol {
    weak var screenListener: ContactsScreenListener?

    @Published var email: String = Strings.Localizable.commonContactEmail

    func handle(event: ContactsScreenInput) {
        switch event {
        case .emailPressed:
            if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .contactInfoPressed:
            screenListener?.contactInfoScreenRequested()
        case .sendFeedback:
            screenListener?.feedbackRequested()
        }
    }
}
