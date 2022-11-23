//
//  PickerViewRadioButton.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2021. 12. 28..
//

import SwiftUI

public struct AlertRadioButtonListAnalyticsData {
    public let contentTypeOverride: String?
    public let selectedLabel: String?
}

public struct AlertRadioButtonList<RadioButtonValueType: Equatable>: View {
    var analyticsData: AlertRadioButtonListAnalyticsData {
        .init(contentTypeOverride: contentTypeOverride,
              selectedLabel: radioButtonOptions
                .dataSet
                .filter({ $0.value == radioButtonOptions.selected })
                .first?
                .title
        )
    }

    var title: String
    @State var radioButtonOptions: RadioButtonOptionSet<RadioButtonValueType>
    var actions: [AlertRadioButtonListAction<RadioButtonValueType>]
    public var contentTypeOverride: String?

    public init(
        title: String,
        radioButtonOptions: RadioButtonOptionSet<RadioButtonValueType>,
        actions: [AlertRadioButtonListAction<RadioButtonValueType>]
    ) {
        self.title = title
        self._radioButtonOptions = State(initialValue: radioButtonOptions)
        self.actions = actions
    }

    public var body: some View {
        Card {
            VStack {
                Text(title)
                    .textStyle(.headings4)
                    .foregroundColor(Color.text.primary)
                Divider()
                HStack {
                    RadioButtonGroup<RadioButtonValueType>(
                        options: $radioButtonOptions,
                        axis: .vertical,
                        state: .normal)
                    Spacer()
                }
                Divider()
                HStack(spacing: .m) {
                    ForEach(actions) { action in
                        DesignButton(
                            style: action.kind == .primary ? .primary : .secondary,
                            size: .large,
                            title: action.title,
                            action: {
                                if let selected = radioButtonOptions
                                    .dataSet
                                    .filter({ $0.value == radioButtonOptions.selected })
                                    .first {
                                    action.handler?(selected.value)
                                    }
                                if action.kind == .primary {
                                    DesignKitModule.analytics?.log(buttonPress: analyticsData)
                                }
                            }
                        ).disableAnalytics()
                    }
                }
            }
        }
    }
}

struct AlertRadioButtonList_Previews: PreviewProvider {
    static var previews: some View {
        AlertRadioButtonList<Int>(
            title: "asd",
            radioButtonOptions: .init(
                dataSet: [
                    ("0 - 150 ezer Ft", 1),
                    ("150 - 300 ezer Ft", 2),
                    ("300 - 500 ezer Ft", 3),
                    ("500 ezer - 10 millió Ft", 4),
                    ("Több mint 10 millió Ft", 5)
                ],
                selected: 2
            ),
            actions: [
                .init(title: "Mégsem", kind: .secondary),
                .init(title: "Rendben", kind: .primary, handler: { _ in
                })
            ]
        )
    }
}

public struct AlertRadioButtonListAction<ValueType: Equatable>: Equatable, Identifiable {
    public enum Kind {
        case primary
        case secondary
        case destructive
    }

    public let id = UUID()
    let title: String
    let kind: Kind
    let handler: ((ValueType) -> Void)?

    public init(
        title: String,
        kind: Kind = .primary,
        handler: ((ValueType) -> Void)? = nil
    ) {
        self.title = title
        self.kind = kind
        self.handler = handler
    }

    public static func == (lhs: AlertRadioButtonListAction, rhs: AlertRadioButtonListAction) -> Bool {
        return lhs.id == rhs.id
    }
}
