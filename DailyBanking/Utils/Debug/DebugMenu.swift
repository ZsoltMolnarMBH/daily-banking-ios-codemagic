//
//  DebugMenu.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 11..
//

#if DEBUG

import Confy
import UIKit
import Resolver
import DesignKit
import BankAPI
import Combine
import SwiftUI

enum DebugMenu {
    static func open() {
        guard navigation == nil else { return }
        let root = makeRootViewController()
        let navigationController = DebugNavigationController(rootViewController: root)
        navigationController.navigationBar.prefersLargeTitles = true

        UIWindow.keyWindow?.rootViewController?.resolveTopPresentedViewController()?.present(navigationController, animated: true)
        navigation = navigationController
    }

    static weak var navigation: UINavigationController?

    static func makeRootViewController() -> DebugViewController {
        let viewController = DebugViewController()
        viewController.items = hierarchy
        viewController.title = "Debug menu"
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                                           target: viewController,
                                                                           action: #selector(DebugViewController.close))
        return viewController
    }

    static var hierarchy: [DebugMenuItem] {
        return [
            DebugMenuItem(title: "📦 Version: \(versionWithBuildNumber)", action: nil),
            DebugMenuItem(title: "ℹ️ Info", action: .navigation({ _ in
                let viewController = DebugViewController()
                viewController.items = infoItems
                return viewController
            })),
            DebugMenuItem(title: "🌳 Environment", action: .navigation({ _ in
                let config: EnvironmentConfig = appCoordinator.container.resolve()
                return Confy.makeConfigListScreen(groups: [config], title: "Environment")
            })),
            DebugMenuItem(title: "🔧 App config", action: .navigation({ _ in
                let appConfig: AppConfig = appCoordinator.container.resolve()
                return Confy.makeConfigListScreen(groups: appConfig.childGroups, title: "App Configuration")
            })),
            DebugMenuItem(title: "✍️ Write markdown", action: .navigation({ navigationController in
                let editor = Self.makeMardownEditor { [weak navigationController] text in
                    let renderer = Self.makeMarkdownRender(text: text)
                    navigationController?.pushViewController(renderer, animated: true)
                }
                return editor
            })),
            DebugMenuItem(title: "💰 Deposit", subtitle: "Deposit 100K HUF to the current account", action: .execution({ _, _ in
                topUp()
            })),
            DebugMenuItem(title: "💢 Fatal error", action: .execution({ _, _ in
                fatalError("Sorry, it was intentional!")
            }))
        ]
    }

    static var infoItems: [DebugMenuItem] {
        var items = [DebugMenuItem]()
        let tokenStore: any TokenStore = appCoordinator.container.resolve()
        if let token = tokenStore.state.value {
            items.append(DebugMenuItem(title: "accessToken", subtitle: token.accessToken, action: .copy))
            items.append(DebugMenuItem(title: "refreshToken", subtitle: token.refreshToken, action: .copy))
            items.append(DebugMenuItem(title: "foregroundSessionExpired", subtitle: "\(token.foregroundSessionExpired)", action: nil))
        }
        let currentToken: ReadOnly<String?> = appCoordinator.container.resolve(name: .app.pushToken)
        if let currentToken = currentToken.value {
            items.append(DebugMenuItem(title: "Current push token", subtitle: currentToken, action: .copy))
        }
        let subscribedToken: any PushSubscriptionStore = appCoordinator.container.resolve()
        items.append(DebugMenuItem(title: "Subscribed push token", subtitle: subscribedToken.state.value ?? "none", action: .copy))
        return items
    }

    static var dateFormatter: DateFormatter {
        let formatetter = DateFormatter()
        formatetter.dateStyle = .medium
        formatetter.timeStyle = .long
        return formatetter
    }

    static var versionWithBuildNumber: String {
        let information: AppInformation = appCoordinator.container.resolve()
        return information.detailedVersion
    }

    static func topUp() {
        guard let main = appCoordinator.childCoordinators.first(where: { $0.tag.contains("main") }) else {
            Modals.toast.show(text: "Please log in before trying to topup")
            return
        }
        let account: ReadOnly<Account?> = main.container.resolve()
        let api: APIProtocol = main.container.resolve()
        guard let account = account.value else {
            Modals.toast.show(text: "Unexpected error :(")
            return
        }

        let mutation = DepositMutation(accountId: account.accountId, amount: 100000)
        api.publisher(for: mutation)
            .sink { completion in
                switch completion {
                case .finished:
                    let action: AccountAction = main.container.resolve()
                    action.refreshAccounts().fireAndForget()
                    Modals.toast.show(text: "💰 Successful topup")
                case .failure:
                    Modals.toast.show(text: "Failed topup")
                }
            } receiveValue: { value in
                if value.deposit.status != .ok {
                    Modals.toast.show(text: "Failed topup")
                }
            }
            .store(in: &GlobalSink.instance.disposeBag)
    }

    static func makeMardownEditor(onRender: @escaping (String) -> Void) -> UIViewController {
        struct Editor: View {
            @State var text: String = ""
            var onRender: (String) -> Void
            var body: some View {
                TextEditor(text: $text)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding(16)
                    .toolbar {
                        Button("Render") {
                            onRender(text)
                        }
                    }
            }
        }
        let editor = Editor(onRender: onRender)
        return UIHostingController(rootView: editor)
    }

    static func makeMarkdownRender(text: String) -> UIViewController {
        let title = "🪄 Rendered"
        let infoScreen = InfoMarkdownScreen(markdown: text)
            .navigationTitle(title)
        let host = UIHostingController(rootView: infoScreen)
        host.title = title
        return host
    }

    static var appCoordinator: AppCoordinator {
        // swiftlint:disable:next force_cast
        return (UIApplication.shared.delegate as! AppDelegate).app
    }
}

private extension DebugMenuItem.Action {
    static var copy: DebugMenuItem.Action {
        return .execution { viewController, item in
            if let value = item.subtitle, value != "" {
                let pasteboard = UIPasteboard.general
                pasteboard.string = value
                let alert = UIAlertController(title: "Copied", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                viewController.present(alert, animated: true)
            }
        }
    }
}

class DebugNavigationController: UINavigationController {
    var onDeinit: (() -> Void)?
    deinit {
        onDeinit?()
    }
}

extension UIViewController {
    func resolveTopPresentedViewController() -> UIViewController? {
        return presentedViewController?.resolveTopPresentedViewController() ?? self
    }
}

#endif
