//
//  PinChangeCoordinator.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 16..
//

import DesignKit
import Combine
import Resolver
import SwiftUI
import UIKit

class PinChangeCoordinator: Coordinator {
    @Injected private var pinVerification: PinVerification
    @Injected var analytics: ViewAnalyticsInterface
    private weak var context: UINavigationController?
    private weak var starting: UIViewController?

    private var oldPin: PinCode?
    private var onFinish: (() -> Void)?

    func start(on context: UINavigationController, onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
        self.context = context
        self.starting = context.topViewController
        showPinVerification()
    }

    private func showPinVerification() {
        pinVerification
            .verifyPin(screenName: "profile_change_pin")
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.onFinish?()
                }
            } receiveValue: { [weak self] pinCode in
                self?.oldPin = pinCode
                self?.showPinInfo()
            }
            .store(in: &disposeBag)
    }

    private func finalize() {
        guard let starting = starting else { return }
        Modals.toast.show(text: Strings.Localizable.pinChangePinChangeSuccessful, onAppear: { [analytics] in
            analytics.logScreenView("profile_change_pin_success")
        })
        context?.popToViewController(starting, animated: true)
    }

    private func showPinInfo() {
        let pinInfo: PinInfoScreen<PinInfoScreenViewModel> = container.resolve()
        pinInfo.viewModel.events
            .sink { [weak self] _ in
                self?.onFinish?()
            } receiveValue: { [weak self] event in
                switch event {
                case .proceed:
                    self?.showPinCreation()
                case .hintRequested:
                    self?.showPinTips()
                }
            }
            .store(in: &disposeBag)

        let screen = pinInfo
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView("profile_create_pin")

        let host = UIHostingController(rootView: screen)
        host.navigationItem.largeTitleDisplayMode = .never
        context?.pushWithCrossfade(host)
    }

    private func showPinCreation() {
        let title = Strings.Localizable.pinChangeCreationScreenTitle
        let screen: PinPadScreen<PinChangeViewModel> = container.resolve()
        screen.viewModel.oldPin = oldPin
        screen.viewModel.events
            .sink { [weak self] event in
                switch event {
                case .finishedPinCreation:
                    self?.finalize()
                case .pinCreationTipsRequested:
                    self?.showPinTips()
                }
            }
            .store(in: &disposeBag)

        let hostingController = UIHostingController(
            rootView: screen
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        )
        hostingController.title = title
        hostingController.navigationItem.largeTitleDisplayMode = .never
        context?.pushViewController(hostingController, animated: true)
    }

    private func showPinTips() {
        let name = "pininfo"
        Modals.bottomInfo.show(
            view: PinCreationInfoDialog { Modals.bottomInfo.dismiss(name) },
            name: name
        )
    }
}
