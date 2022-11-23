//
//  DesignKit+ImageNames.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 13..
//

import Foundation
import DesignKit

extension DesignButton {
    init(
        style: Style = .primary,
        width: Width = .fullSize,
        size: Size = .large,
        title: String? = nil,
        imageName: ImageName,
        action: @escaping () -> Void) {
        self.init(style: style,
                  width: width,
                  size: size,
                  title: title,
                  imageName: imageName.rawValue,
                  action: action)
    }
}

extension VerticalButton {
    init(text: String, imageName: ImageName, style: Style, action: @escaping () -> Void) {
        self.init(text: text,
                  imageName: imageName.rawValue,
                  style: style,
                  action: action)
    }
}

extension EmptyStateView.ViewModel {
    init(imageName: ImageName, title: String, description: String?) {
        self.init(imageName: imageName.rawValue,
                  title: title,
                  description: description)
    }
}

extension SectionHeader.ButtonData {
    init(image: ImageName, action: @escaping (() -> Void)) {
        self.init(imageName: image.rawValue, action: action)
    }
}
