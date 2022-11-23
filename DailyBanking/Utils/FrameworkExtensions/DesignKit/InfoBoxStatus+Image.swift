//
//  InfoBoxStatus+Image.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 05. 09..
//

import DesignKit
import SwiftUI

extension InfoBox {
    init(
        cornerRadius: CGFloat = .l,
        status: Status,
        title: String,
        subtitle: String,
        actionTitle: String = "",
        action: (() -> Void)? = nil,
        closeAction: (() -> Void)? = nil
    ) {
        self.init(cornerRadius: cornerRadius,
                  status: status,
                  image: status.image,
                  title: title,
                  subtitle: subtitle,
                  actionTitle: actionTitle,
                  action: action,
                  closeAction: closeAction)
    }
}

extension InfoBox.Status {
    var image: Image {
        switch self {
        case .warning:
            return Image(.warningSemantic)
        case .error:
            return Image(.alertSemantic)
        case .success:
            return Image(.successSemantic)
        case .info:
            return Image(.infoSemantic)
        }
    }
}
