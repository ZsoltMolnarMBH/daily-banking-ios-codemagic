//
//  SecondaryIdListComponent.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 11..
//

import SwiftUI
import Combine
import DesignKit

protocol ProxyIdListComponentViewModelProtocol: ObservableObject {
    var items: [ProxyId] { get }
    var actionSheet: AnyPublisher<ActionSheetModel, Never> { get }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }
    func handle(event: ProxyIdListComponentEvent)
}

enum ProxyIdListComponentEvent {
    case add
    case delete(proxyId: ProxyId)
}

struct ProxyIdListComponent<ViewModel: ProxyIdListComponentViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        if viewModel.items.isEmpty {
            HStack {
                Spacer(minLength: 0)
                VStack(alignment: .center, spacing: 0) {
                    Image(.bulb)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .padding(.bottom, .m)
                    Text(Strings.Localizable.accountDetailsSecondaryAccountLearningCardTitle)
                        .textStyle(.headings4.thin)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.bottom], .xs)
                    Text(Strings.Localizable.accountDetailsSecondaryAccountLearningCardDescription)
                        .textStyle(.body2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, .m)
                    DesignButton(style: .secondary,
                                 width: .fluid,
                                 size: .medium,
                                 title: Strings.Localizable.accountDetailsSecondaryAccountLearningCardButton,
                                 imageName: DesignKit.ImageName.bankCard) {
                        viewModel.handle(event: .add)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.m)
        } else {
            VStack {
                ForEach(Array(viewModel.items.enumerated()), id: \.offset) { item in
                    HStack {
                        InfoView(title: item.element.kind.localized,
                                 text: item.element.formattedValue,
                                 chips: [item.element.status.chip].compactMap { $0 })
                        Spacer()
                        Button {
                            viewModel.handle(event: .delete(proxyId: item.element))
                            analytics.logButtonPress(
                                contentType: "card kebab icon",
                                componentLabel: nil
                            )
                        } label: {
                            Image(DesignKit.ImageName.menu21)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.text.tertiary)
                        }
                    }
                }
                DesignButton(style: .tertiary,
                             width: .fullSize,
                             size: .large,
                             title: Strings.Localizable.accountDetailsSecondaryBottomSheetOtherSecondaryIds,
                             imageName: DesignKit.ImageName.add) {
                    viewModel.handle(event: .add)
                }
                .analyticsOverride(contentType: "card tertiary button")
            }
            .actionSheet(viewModel.actionSheet)
            .designAlert(viewModel.bottomAlert)
        }
    }
}

extension ProxyId.Status {
    var chip: ChipView? {
        switch self {
        case .expired:
            return ChipView(
                text: Strings.Localizable.secondaryIdStatusExpired,
                backgroundColor: .error.secondary.background,
                textColor: .error.secondary.foreground,
                size: .small
            )
        case .expiresSoon:
            return ChipView(
                text: Strings.Localizable.secondaryIdStatusExpireSoon,
                backgroundColor: .warning.secondary.background,
                textColor: .warning.secondary.foreground,
                size: .small
            )
        case .activatesSoon:
            return ChipView(
                text: Strings.Localizable.secondaryIdStatusPendingApproval,
                backgroundColor: .info.secondary.background,
                textColor: .info.secondary.foreground,
                size: .small
            )
        case .active:
            return nil
        }
    }
}

struct ProxyIdListComponent_Previews: PreviewProvider {
    static var previews: some View {
        FullHeightScrollView {
            SectionCard {
                ProxyIdListComponent(viewModel: MockProxyIdListViewModel())
            }
        }
        .padding()
        .background(Color.background.secondary)
        .preferredColorScheme(.dark)
    }
}

class MockProxyIdListViewModel: ProxyIdListComponentViewModelProtocol {
    var actionSheet: AnyPublisher<ActionSheetModel, Never> = PassthroughSubject().eraseToAnyPublisher()
    var bottomAlert: AnyPublisher<AlertModel, Never> = PassthroughSubject().eraseToAnyPublisher()
    var items: [ProxyId] = [
        ProxyId(kind: .emailAddress, status: .active, value: "teszt.jani@mails.com"),
        ProxyId(kind: .emailAddress, status: .activatesSoon, value: "teszt.jani.new@mails.com"),
        ProxyId(kind: .phoneNumber, status: .expiresSoon, value: "+36 30 1234567"),
        ProxyId(kind: .phoneNumber, status: .expired, value: "+36 30 1234567")
    ]

    func handle(event: ProxyIdListComponentEvent) {
        // Nothing to do in mock
    }
}
