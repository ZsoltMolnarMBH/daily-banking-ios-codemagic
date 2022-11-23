//
//  CheckBoxRow.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 12. 12..
//

import SwiftUI

public struct CheckBoxRow: View {
    public struct AnalyticsData {
        public let contentTypeOverride: String?
        public let text: String?
        public let isChecked: Bool
    }
    var analyticsData: AnalyticsData {
        .init(contentTypeOverride: contentTypeOverride,
              text: text,
              isChecked: isChecked)
    }

    @Binding var isChecked: Bool
    var text: String
    var textDidPress: (() -> Void)?
    var linkHandler: ((URL) -> Void)?
    public var contentTypeOverride: String?

    public init(isChecked: Binding<Bool>, text: String, textDidPress: (() -> Void)? = nil) {
        self._isChecked = isChecked
        self.text = text
        self.textDidPress = textDidPress
    }

    public var body: some View {
        HStack(spacing: 0) {
            CheckBox(isChecked: $isChecked)
                .padding([.trailing], .m)
            Markdown(text)
                .onLinkTapped { url in
                    linkHandler?(url)
                }
                .onTapGesture {
                    textDidPress?()
                }
            Spacer()
        }
        .onChange(of: isChecked) { _ in
            DesignKitModule.analytics?.log(buttonPress: analyticsData)
        }
    }

    public func onLinkTapped(_ linkHandler: ((URL) -> Void)?) -> CheckBoxRow {
        var view = self
        view.linkHandler = linkHandler
        return view
    }
}

struct CheckBoxRow_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxRow(
            isChecked: .constant(true),
            text: "Elfogadom a [Felhasználási feltételeket](terms).",
            textDidPress: {}
        )
    }
}

struct CheckBoxRowDark_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxRow(
            isChecked: .constant(true),
            text: "Elfogadom a [Felhasználási feltételeket](terms).",
            textDidPress: {}
        ).preferredColorScheme(.dark)
    }
}
