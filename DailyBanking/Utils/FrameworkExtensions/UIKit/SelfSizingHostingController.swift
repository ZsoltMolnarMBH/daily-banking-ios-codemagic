//
//  SelfSizingHostingController.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 16..
//

import UIKit
import SwiftUI

class SelfSizingHostingController<Content>: UIHostingController<Content> where Content: View {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Note:
        // Sometimes infinite layout cycle occurs by calling invalidateIntrinsicContentSize()
        // and that time the frame's height constantly growing even beyond the screen height.
        if view.frame.size.height <= UIScreen.main.bounds.size.height {
            self.view.invalidateIntrinsicContentSize()
        }
    }
}
