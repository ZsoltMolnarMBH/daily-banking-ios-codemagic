//
//  CardsCoordinator.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import Combine
import SwiftUI
import Resolver
import DesignKit

class BankCardsCoordinator: Coordinator {
    @Injected var cardInfoStore: any BankCardInfoStore
    @Injected var cardPinStore: any BankCardPinStore
    private weak var context: UINavigationController?
    private var onFinished: (() -> Void)?

    private weak var launchScreen: UIViewController?

    func start(on contex: UINavigationController, onFinished: @escaping () -> Void) {
        self.context = contex
        self.onFinished = onFinished
        startBankCardScreen(on: contex)
    }

    private func startBankCardScreen(on contex: UINavigationController) {
        let title = Strings.Localizable.bankCardDetailsTitle
        let view = container.resolve(BankCardScreen<BankCardScreenViewModel>.self)
        view.viewModel.screenListener = self
        view.viewModel.onFinished = self.onFinished
        let hostingController = UIHostingController(
            rootView: view
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        hostingController.hidesBottomBarWhenPushed = true
        launchScreen = hostingController
        context?.pushViewController(hostingController, animated: true)
    }
}

extension BankCardsCoordinator: BankCardScreenListener {

    func reorderCardRequested(cardToken: String) {

        guard let context = context else { return }

        let title = Strings.Localizable.bankCardReorder
        let view = container.resolve(BankCardReorderScreen<BankCardReorderViewModel>.self)
        view.viewModel.screenListener = self
        let hostingController = UIHostingController(
            rootView: view
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        if cardToken == "" {
            var viewControllers = context.viewControllers

            _ = viewControllers.popLast()
            viewControllers.append(hostingController)
            context.setViewControllers(viewControllers, animated: true)
        } else {
            context.pushViewController(hostingController, animated: true)
        }
    }

    func blockCardRequested(cardToken: String) {
        let view = container.resolve(BankCardBlockScreen<BankCardBlockViewModel>.self)
        view.viewModel.screenListener = self
        view.viewModel.cardToken = cardToken
        view.viewModel.onClose = { [weak self] in
            self?.popBackToCardDetails()
        }
        let title = Strings.Localizable.bankCardBlockScreenNavigationTitle
        let hostingController = UIHostingController(
            rootView: view
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        hostingController.hidesBottomBarWhenPushed = true
        context?.pushViewController(hostingController, animated: true)
    }

    func cardInfoRequested() {
        let name = "BankCardInfoScreen"
        let screen = container.resolve(BankCardInfoScreen<BankCardInfoScreenViewModel>.self)
        screen.viewModel.onClose = { Modals.bottomSheet.dismiss(name) }

        Modals.bottomSheet.show(
            view: screen.onAppWillResignActive { Modals.bottomSheet.dismiss(name) },
            name: name,
            backgroundColor: .background.secondary
        )
    }

    func pinCodeRevealRequested() {
        let name = "PinCodeRevealScreen"
        let screen = container.resolve(PinCodeRevealScreen<PinCodeRevealScreenViewModel>.self)
        screen.viewModel.onClose = { Modals.bottomSheet.dismiss(name) }

        Modals.bottomSheet.show(
            view: screen.onAppWillResignActive {
                Modals.bottomSheet.dismiss(name)
            },
            name: name,
            backgroundColor: .background.secondary
        )
    }

    func helpRequested() {
        ActionSheetView(.contactsAndHelp).show()
    }

    func cardLimitRequested() {
        let title = Strings.Localizable.bankCardDetailsSetLimits
        let view = container.resolve(BankCardLimitStartPageScreen<BankCardLimitStartPageScreenViewModel>.self)
        view.viewModel.screenListener = self
        let hostingController = UIHostingController(
            rootView: view
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        context?.pushViewController(hostingController, animated: true)
    }

    func popBackToCardDetails() {
        if let launchScreen = launchScreen {
            context?.popToViewController(launchScreen, animated: true)
        }
    }
}

extension BankCardsCoordinator: BankCardReorderScreenListener {

    func pinSetupRequested() {
        let title = BankCardPinSetupState.enterFirstPin.screenTitle
        let view = container.resolve(BankCardPinSetupScreen<BankCardPinSetupViewModel>.self)
        view.viewModel.pinSetupState = .enterFirstPin
        view.viewModel.screenListener = self
        let hostingController = UIHostingController(
            rootView: view
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        context?.pushViewController(hostingController, animated: true)
    }

    func addressInfoRequested() {
        let title = Strings.Localizable.bankCardPostingAddress
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.bankCardPostingAddressInfoMarkdown) { [weak context] in
                context?.dismiss(animated: true, completion: nil)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .addClose { [weak context] in
                context?.dismiss(animated: true, completion: nil)
            }

        let hosting = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        context?.present(hosting, animated: true)
    }
}

extension BankCardsCoordinator: BankCardPinSetupScreenListener {

    func pinInfoTipsRequested(dismissed: @escaping () -> Void) {
        showPinTips(dismissed: dismissed)
    }

    private func showPinTips(dismissed: @escaping () -> Void) {
        let name = "pininfo"
        Modals.bottomInfo.show(
            view: PinCreationInfoDialog(pinType: .cardPin, onDismiss: {
                Modals.bottomInfo.dismiss(name)
            }).onDisappear(perform: {
                dismissed()
            }),
            name: name
        )
    }

    func pinSetupEnded() {
        popBackToCardDetails()
    }

    func pinSetupCancelled() {
        context?.popViewController(animated: true)
    }

    func reorderCancelled() {
        popBackToCardDetails()
    }
}

extension BankCardsCoordinator: BankCardBlockScreenListener {

    func blockCancelled() {
        popBackToCardDetails()
    }

    func resultRequested() {
        let model: AlertModel = .bankCardBlockSuccess {
            self.reorderCardRequested(cardToken: "")
        } skipAction: {
            self.popBackToCardDetails()
        }

        let alert = DesignAlertView(
            with: model,
            onActionSelected: {
                Modals.bottomAlert.dismiss(model.uuid)
            }
        )

        Modals.bottomAlert.show(
            view: alert,
            name: model.uuid
        )
    }
}

extension BankCardsCoordinator: BankCardLimitStartPageScreenListener {
    func creditCardLimitScreenRequested() {
        let title = Strings.Localizable.bankCardLimitStartPageCreditCardLimit
        let view = container.resolve(BankCardCreditCardLimitScreen<BankCardCreditCardLimitScreenViewModel>.self)
        view.viewModel.screenListener = self
        let hostingController = UIHostingController(
            rootView: view
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        context?.pushViewController(hostingController, animated: true)
    }

    func cashWithdrawlLimitScreenRequested() {
        let title = Strings.Localizable.bankCardLimitStartPageCashWithdrawalLimit
        let view = container.resolve(BankCardCashWithdrawalLimitScreen<BankCardCashWithdrawalLimitScreenViewModel>.self)
        view.viewModel.screenListener = self
        let hostingController = UIHostingController(
            rootView: view
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        context?.pushViewController(hostingController, animated: true)
    }
}

extension BankCardsCoordinator: BankCardCreditCardLimitScreenListener, BankCardCashWithdrawalLimitScreenListener {

    func creditCardOnlineLimitInfoRequested() {
        let title = Strings.Localizable.bankCardLimitCreditCardOnlineInfoTitle
        let screen = InfoMarkdownScreen(markdown: Strings.Localizable.bankCardCreditLimitInfoMarkdown) { [weak context] in
                context?.dismiss(animated: true, completion: nil)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .addClose { [weak context] in
                context?.dismiss(animated: true, completion: nil)
            }

        let hosting = UINavigationController(rootViewController: UIHostingController(rootView: screen))
        context?.present(hosting, animated: true)
    }

    func limitChangeCancelled() {
        self.popBackToCardDetails()
    }
}
