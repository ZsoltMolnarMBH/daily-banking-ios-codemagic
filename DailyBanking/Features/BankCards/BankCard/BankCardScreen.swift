//
//  CardScreen.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import SwiftUI
import DesignKit

protocol BankCardScreenViewModelProtocol: ObservableObject {
    var cardName: String { get }
    var cardNumberLastDigits: String { get }
    var cardState: BankCard.State { get }
    var isLoading: Bool { get }
    var isLoadingFullScreen: Bool { get }

    var freezeButtonLabel: String { get }
    var freezeButtonStyle: VerticalButton.Style { get }

    var infoBoxParams: BankCardInfoBoxParams? { get }
    var statusViewParams: BankCardStatusViewParams? { get }

    func handle(_ event: BankCardScreenInput)
}

enum BankCardScreenInput {
    case help
    case cardInfo
    case showPin
    case freezeCard
    case cardLimit
    case blockCard
    case orderCard
    case onAppear
}

extension BankCard.State {
    var label: String {
        switch self {
        case .active, .transactionDBFailure: return ""
        case .frozen: return Strings.Localizable.bankCardDetailsStateFrozen
        case .blocked: return Strings.Localizable.bankCardDetailsStateBanned
        case .transactionTMLinkFailed: return Strings.Localizable.bankCardDetailsStateInProgress
        }
    }

    var backgroundColor: Color {
        switch self {
        case .active, .transactionDBFailure: return .clear
        case .frozen, .transactionTMLinkFailed: return .info.secondary.background
        case .blocked: return .error.secondary.background
        }
    }

    var foregroundColor: Color {
        switch self {
        case .active, .transactionDBFailure: return .clear
        case .frozen, .transactionTMLinkFailed: return .info.secondary.foreground
        case .blocked: return .error.secondary.foreground
        }
    }

    var shouldHideStateLabel: Bool {
        switch self {
        case .active:
            return true
        default:
            return false
        }
    }

    var shouldHideOrderNewCard: Bool {
        switch self {
        case .blocked:
            return false
        default:
            return true
        }
    }

    var shouldHideOptions: Bool {
        switch self {
        case .blocked, .transactionDBFailure, .transactionTMLinkFailed:
            return true
        default:
            return false
        }
    }

    var cardInfoDisabled: Bool {
        return self == .frozen
    }

    var pinCodeRevealDisabled: Bool {
        switch self {
        case .frozen:
            return true
        default:
            return false
        }
    }

    var freezeDisabled: Bool {
        return false
    }
}

struct BankCardScreen<ViewModel: BankCardScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                if !viewModel.cardState.shouldHideOrderNewCard {
                    InfoBox(
                        status: .warning,
                        title: Strings.Localizable.bankCardOrderNewCardTitle,
                        subtitle: Strings.Localizable.bankCardOrderNewCardDescription,
                        actionTitle: Strings.Localizable.bankCardOrderNewCard, action: {
                            self.viewModel.handle(.orderCard)
                        })
                }
                BankCardPlaceholderView(cardNumberLastDigits: viewModel.cardNumberLastDigits)
                if !viewModel.cardState.shouldHideStateLabel {
                    ChipView(
                        text: viewModel.cardState.label,
                        backgroundColor: viewModel.cardState.backgroundColor,
                        textColor: viewModel.cardState.foregroundColor,
                        size: .medium)
                }
                Text(viewModel.cardName)
                    .textStyle(.headings3.thin)
                    .foregroundColor(.text.primary)
                if !viewModel.cardState.shouldHideOptions {
                    BankCardMainOptionsView(viewModel: viewModel)
                    if let params = viewModel.infoBoxParams {
                        InfoBox(status: params.status, title: params.title, subtitle: params.subtitle)
                    }
                    BankCardOtherOptionsView(viewModel: viewModel)
                }
                if let params = viewModel.statusViewParams {
                    BankCardStatusView(viewModel: viewModel, image: params.image, title: params.title, subtitle: params.subtitle)
                }
                Spacer()
            }
            .padding(.horizontal, .l)
        }
        .background(Color.background.secondary)
        .shimmeringPlaceholder(when: viewModel.isLoading, for: .background.secondary)
        .animation(.default, value: viewModel.isLoading)
        .fullScreenProgress(by: viewModel.isLoadingFullScreen, name: "bankcardscreen")
        .analyticsScreenView("card_details")
        .onAppear(perform: {
            viewModel.handle(.onAppear)
        })
    }
}

class MockBankCardScreenViewModel: BankCardScreenViewModelProtocol {
    var isLoading: Bool = false
    var cardReordered: Bool = false
    var isLoadingFullScreen: Bool = true
    var freezeButtonLabel: String { cardState == .frozen ?
        Strings.Localizable.bankCardDetailsUnfreezeCard : Strings.Localizable.bankCardDetailsFreezeCard }
    var freezeButtonStyle: VerticalButton.Style { cardState == .frozen ? .primary : .secondary }
    var cardName: String = "Mastercard World Elite"
    var cardNumberLastDigits: String = "****"
    var cardState: BankCard.State = .frozen

    var infoBoxParams: BankCardInfoBoxParams? {
        switch cardState {
        case .frozen:
            return
                .init(
                    status: .info,
                    title: Strings.Localizable.bankCardDetailsStateFrozenIntoTitle,
                    subtitle: Strings.Localizable.bankCardDetailsStateFrozenIntoDescription)
        default: return nil
        }
    }

    var statusViewParams: BankCardStatusViewParams? {
        switch cardState {
        case .blocked:
            return nil
        default: return nil
        }
    }

    func handle(_ event: BankCardScreenInput) {}
}

struct BankCardScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardScreen(viewModel: MockBankCardScreenViewModel())
            .preferredColorScheme(.light)
    }
}
