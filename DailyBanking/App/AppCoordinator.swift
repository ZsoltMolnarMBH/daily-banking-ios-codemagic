//
//  AppCoordinator.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 15..
//

import Combine
import DesignKit
import Resolver
import SwiftUI
import UIKit
import KeychainAccess

class AppCoordinator: Coordinator {
    @LazyInjected var authState: ReadOnly<AuthState>
    @LazyInjected var keychain: Keychain
    @LazyInjected var fullScreenCover: FullScreenCover
    @Injected var forceUpdateSignal: ForceUpdateSignalReceiver
    @Injected var reachabilityMonitor: ReachabilityMonitor

    private weak var context: UIWindow?
    private var currentAuthState: AuthState?
    private let userDefaults = UserDefaults.standard

    override init(container: Resolver) {
        super.init(container: container)
        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.didEnterBackgroundNotification
        ).sink { [weak self] _ in
            self?.fullScreenCover.show()
        }
        .store(in: &disposeBag)

        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.willEnterForegroundNotification
        ).sink { [weak self] _ in
            self?.fullScreenCover.hide()
        }
        .store(in: &disposeBag)

        forceUpdateSignal
            .publisher
            .sink(receiveValue: { _ in
                // Currently we have only blocking signals
                // opening Testflight app is a temporary solution
                Modals.bottomAlert.show(alert: .blockingForceUpdate(onUpdateRequest: {
                    let url = URL(string: "itms-beta://")
                    if let url = url, UIApplication.shared.canOpenURL(url),
                       let appUrl = URL(string: "https://beta.itunes.apple.com/v1/app/1598162846") {
                        UIApplication.shared.open(appUrl)
                    }
                }))
            })
            .store(in: &disposeBag)

        reachabilityMonitor.publisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .scan((from: ReachabilityMonitor.State.undefined, to: ReachabilityMonitor.State.undefined)) {
                ($0.1, $1)
            }
            .handleEvents(receiveOutput: { _ in
                Modals.reachabilityAlert.dismissAll()
            })
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { stateChange in
                if stateChange.to == .unreachable {
                    Modals.reachabilityAlert.show(
                        view: ReachabilityStateView(state: .unreachable),
                        presentInSelfSizingController: true
                    )
                } else if stateChange.from == .unreachable, stateChange.to == .reachable {
                    Modals.reachabilityAlert.show(
                        view: ReachabilityStateView(state: .reachable),
                        duration: 3,
                        presentInSelfSizingController: true
                    )
                }
            }.store(in: &disposeBag)
    }

    func start(context: UIWindow) {
        self.context = context
        handleFirstLaunch()
        subscribeToAuthState()
        handle(authState: authState.value)
    }

    private func handleFirstLaunch() {
        let key = "alreadyLaunched"
        if userDefaults.bool(forKey: key) == false {
            try? keychain.removeAll()
            userDefaults.set(true, forKey: key)
        }
    }

    private func handle(authState: AuthState) {
        guard authState != currentAuthState else { return }
        currentAuthState = authState
        switch authState {
        case .initial:
            showRegistration()
        case .activated:
            showLogin()
        case .authenticated:
            showDashboard()
        }
    }

    private func subscribeToAuthState() {
        authState.publisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(authState: state)
            }
            .store(in: &disposeBag)
    }

    private func showRegistration() {
        childCoordinators.removeAll()
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: RegistrationAssembly()) { container in
                RegistrationCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(on: context)
    }

    private func showLogin() {
        childCoordinators.removeAll()
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: LoginAssembly()) { container in
                LoginCoordinator(container: container)
            }
        add(child: coordinator)
        coordinator.start(on: context)
    }

    private func showDashboard() {
        childCoordinators.removeAll()
        let coordinator = Coordinator.make(
            using: container.makeChild(),
            assembly: MainAssembly()) { container in
                MainCoordinator(container: container)
        }
        add(child: coordinator)
        coordinator.start(on: context)
    }
}
