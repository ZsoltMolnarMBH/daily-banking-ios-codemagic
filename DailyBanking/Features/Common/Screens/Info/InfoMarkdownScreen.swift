//
//  InfoMarkdownScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 05. 13..
//

import SwiftUI
import DesignKit

struct InfoMarkdownScreen: View {
    var markdown: String
    var onAcknowledge: (() -> Void)?
    var acknowledgeTitle = Strings.Localizable.commonAllRight

    var body: some View {
        FormLayout {
            Markdown(markdown)
                .padding()
            Spacer()
        } floater: {
            if let onAcknowledge = onAcknowledge {
                DesignButton(title: acknowledgeTitle) {
                    onAcknowledge()
                }
            } else {
                EmptyView()
            }
        }
    }
}

extension InfoMarkdownScreen {
    func acknowledge(onAcknowledge: (() -> Void)?) -> Self {
        var view = self
        view.onAcknowledge = onAcknowledge
        return view
    }

    func acknowledge(title: String) -> Self {
        var view = self
        view.acknowledgeTitle = title
        return view
    }
}

// swiftlint:disable all
struct InfoMarkdownScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoMarkdownScreen(
            markdown: .markdownSample,
            onAcknowledge: {},
            acknowledgeTitle: "Tovább").preferredColorScheme(.light)
    }
}
// swiftlint:enable all
