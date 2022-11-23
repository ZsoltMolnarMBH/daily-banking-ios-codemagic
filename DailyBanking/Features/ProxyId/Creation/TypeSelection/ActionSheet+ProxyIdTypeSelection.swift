//
//  ActionSheet+ProxyIdTypeSelection.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 25..
//

import Foundation
import DesignKit

extension ActionSheetModel {
    static func proxyIdTypeSelection(
        from account: Account,
        of individual: Individual,
        onTypeSelected: @escaping (ProxyId.Kind, String?) -> Void,
        onOtherSelected: @escaping () -> Void
    ) -> ActionSheetModel {
        let currentProxyIds = account.proxyIds
        var items = ProxyId.Kind.allCases
            .filter { kind in
                !currentProxyIds.contains { $0.kind == kind } && kind != .unknown
            }
            .sorted { $0.sortOrder < $1.sortOrder }
            .compactMap { kind -> ActionSheetModel.Item? in
                let provisionedValue = kind.provisionedValue(using: individual)
                let subtitle: String?
                if let provisionedValue = provisionedValue {
                    subtitle = ProxyId.formatted(value: provisionedValue, using: kind)
                } else {
                    subtitle = nil
                }
                return ActionSheetModel.Item(
                    title: kind.localized,
                    subtitle: subtitle,
                    iconName: kind.icon?.rawValue,
                    action: { onTypeSelected(kind, provisionedValue) })
            }

        items.append(ActionSheetModel.Item(
            title: Strings.Localizable.accountDetailsSecondaryAccountCardAddButton,
            subtitle: nil,
            iconName: DesignKit.ImageName.add.rawValue,
            action: { onOtherSelected() })
        )

        return .init(
            title: Strings.Localizable.accountDetailsSecondaryBottomSheetTitle,
            items: items
        )
    }
}

private extension ProxyId.Kind {
    var sortOrder: Int {
        switch self {
        case .phoneNumber:
            return 1
        case .emailAddress:
            return 2
        case .taxId:
            return 3
        case .unknown:
            return 4
        }
    }

    var icon: DesignKit.ImageName? {
        switch self {
        case .emailAddress:
            return .messageUnread
        case .phoneNumber:
            return .phoneOn
        case .taxId:
            return .id
        case .unknown:
            return nil
        }
    }

    func provisionedValue(using individual: Individual) -> String? {
        switch self {
        case .emailAddress:
            return individual.email.address
        case .phoneNumber:
            return individual.phoneNumber
        case .taxId:
            return nil
        case .unknown:
            return nil
        }
    }
}
