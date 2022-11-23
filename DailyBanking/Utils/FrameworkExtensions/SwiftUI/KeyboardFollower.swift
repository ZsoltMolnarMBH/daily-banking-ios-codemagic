//
//  KeyboardFollower.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 26..
//

import Combine
import Foundation
import UIKit

class KeyboardFollower: ObservableObject {

    enum KeyboardState: Equatable {
        case hidden
        case visible(height: CGFloat)

        var isVisible: Bool {
            if case .visible = self {
                return true
            }
            return false
        }

        var height: CGFloat {
            switch self {
            case .hidden:
                return 0
            case .visible(let height):
                return height
            }
        }
    }

    @Published var state: KeyboardState = .hidden

    init() {
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .map { notification -> KeyboardState? in
                guard let userInfo = notification.userInfo,
                      let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return nil
                }

                let isVisible = keyboardEndFrame.minY < UIScreen.main.bounds.height
                return isVisible ? .visible(height: keyboardEndFrame.height) : .hidden
            }
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: &$state)
    }
}
