//
//  Dialogs.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 23..
//

import Foundation
import DesignKit
import SwiftEntryKit
import SwiftUI

struct Modals {
    enum HapticFeedback {
        case success
        case warning
        case error
        case none
    }

    static let progress = AnyModal(EKAttributes.alertAttributes(level: .normal + 2))
    static let bottomSheet = BottomSheet(level: .normal + 3)
    static let fullScreen = AnyModal(EKAttributes.fullScreenAttributes(level: .statusBar))
    static let alert = AnyModal(EKAttributes.alertAttributes(level: .alert - 4))
    static let pinPadOverlay = AnyModal(EKAttributes.pinOverlayAttributes(level: .alert - 3))
    static let bottomAlert = AnyModal(EKAttributes.bottomAlertAttributes(level: .alert - 2))
    static let bottomInfo = AnyModal(EKAttributes.bottomInfoAttributes(level: .alert - 1))
    static let toast = Toast(level: .alert + 1)
    static let reachabilityAlert = AnyModal(EKAttributes.reachabilityAlertAttributes(level: .alert + 2))

    static func dismissAll() {
        progress.dismissAll()
        bottomSheet.dismissAll()
        fullScreen.dismissAll()
        alert.dismissAll()
        pinPadOverlay.dismissAll()
        bottomAlert.dismissAll()
    }
}

private extension Modals.HapticFeedback {
    var ekFeedback: EKAttributes.NotificationHapticFeedback {
        switch self {
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        case .none:
            return .none
        }
    }
}

struct AnyModal: ModalPresentation {
    let swiftEntryKit = SwiftEntryKit()
    let attributes: EKAttributes

    fileprivate init(_ attributes: EKAttributes) {
        self.attributes = attributes
    }

    func show<T: View>(
        view: T,
        name: String? = nil,
        hapticFeedbackType: Modals.HapticFeedback = .none,
        duration: EKAttributes.DisplayDuration = .infinity,
        presentInSelfSizingController: Bool = false,
        onClose: (() -> Void)? = nil
    ) {
        var attributes = self.attributes
        attributes.hapticFeedbackType = hapticFeedbackType.ekFeedback
        attributes.lifecycleEvents.didDisappear = onClose
        attributes.name = name
        attributes.displayDuration = duration
        if presentInSelfSizingController {
            presentSelfSizingController(view: view, attributes: attributes)
        } else {
            present(view: view, attributes: attributes)
        }
    }

    func show(
        viewController: UIViewController,
        name: String? = nil,
        hapticFeedbackType: Modals.HapticFeedback = .none,
        onClose: (() -> Void)? = nil
    ) {
        var attributes = self.attributes
        attributes.hapticFeedbackType = hapticFeedbackType.ekFeedback
        attributes.lifecycleEvents.didDisappear = onClose
        attributes.name = name
        present(viewController: viewController, attributes: attributes)
    }

    func show(
        alert: AlertModel,
        hapticFeedbackType: Modals.HapticFeedback = .none,
        onClose: (() -> Void)? = nil
    ) {
        var attributes = self.attributes
        attributes.hapticFeedbackType = hapticFeedbackType.ekFeedback
        attributes.lifecycleEvents.didDisappear = onClose
        attributes.name = alert.uuid
        let alertView = DesignAlertView(
            with: alert,
            onActionSelected: {
                dismiss(alert.uuid)
            })
        present(view: alertView, attributes: attributes)
    }
}

struct BottomSheet: ModalPresentation {
    let swiftEntryKit = SwiftEntryKit()
    let attributes: EKAttributes

    fileprivate init(level windowLevel: UIWindow.Level) {
        self.attributes = .bottomSheetAttributes(level: windowLevel)
    }

    func show<T: View>(
        view: T,
        name: String? = nil,
        backgroundColor: Color?,
        onClose: (() -> Void)? = nil
    ) {
        var attributes = self.attributes
        attributes.lifecycleEvents.didDisappear = onClose
        attributes.name = name
        let sheetView = BottomSheetView(backgroundColor: backgroundColor ?? .background.secondary) { view }
        present(view: sheetView, attributes: attributes)
    }
}

struct Toast {
    enum Duration {
        case short
        case long
        case custom(TimeInterval)

        var timeInterval: TimeInterval {
            switch self {
            case .short:
                return 2.0
            case .long:
                return 5.0
            case let .custom(timeInterval):
                return timeInterval
            }
        }
    }

    private let swiftEntryKit = SwiftEntryKit()
    let level: UIWindow.Level

    fileprivate init(level: UIWindow.Level) {
        self.level = level
    }

    func show(
        text: String,
        duration: Duration = .short,
        overrideUserInterfaceStyle: UIUserInterfaceStyle? = nil,
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil
    ) {
        if swiftEntryKit.isCurrentlyDisplaying(entryNamed: text) || swiftEntryKit.queueContains(entryNamed: text) {
            return
        }
        var attributes = EKAttributes.bottomSnackbarAttributes(
            level: level,
            duration: duration.timeInterval
        )
        attributes.lifecycleEvents.didDisappear = onDisappear
        attributes.lifecycleEvents.didAppear = onAppear
        attributes.name = text

        let host = UIHostingController(rootView: ToastView(text: text))
        if let override = overrideUserInterfaceStyle {
            host.overrideUserInterfaceStyle = override
        }
        host.view.backgroundColor = .clear
        swiftEntryKit.display(entry: host, using: attributes)
    }
}

protocol ModalPresentation {
    var swiftEntryKit: SwiftEntryKit { get }
    var attributes: EKAttributes { get }
    func dismiss(_ name: String)
    func dismissAll()
}

extension ModalPresentation {
    func present<T: View>(
        view: T,
        attributes: EKAttributes
    ) {
        UIWindow.keyWindow?.endEditing(true)
        let host = UIHostingController(rootView: view)
        host.view.backgroundColor = .clear
        swiftEntryKit.display(entry: host, using: attributes)
    }

    func presentSelfSizingController<T: View>(
        view: T,
        attributes: EKAttributes
    ) {
        UIWindow.keyWindow?.endEditing(true)
        let host = SelfSizingHostingController(rootView: view)
        host.view.backgroundColor = .clear
        swiftEntryKit.display(entry: host, using: attributes)
    }

    func present(
        viewController: UIViewController,
        attributes: EKAttributes
    ) {
        UIWindow.keyWindow?.endEditing(true)
        swiftEntryKit.display(entry: viewController, using: attributes)
    }

    func dismiss(_ name: String) {
        swiftEntryKit.dismiss(.specific(entryName: name))
    }

    func dismissAll() {
        swiftEntryKit.dismiss(.all)
    }
}

// swiftlint:disable all
fileprivate extension EKAttributes {
    static func alertAttributes(level: UIWindow.Level) -> EKAttributes {
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        var attributes = EKAttributes.centerFloat
        attributes.windowLevel = .custom(level: level)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        attributes.hapticFeedbackType = .none
        attributes.displayDuration = .infinity
        attributes.entryBackground = .clear
        attributes.screenBackground = .visualEffect(style: .init(light: .systemUltraThinMaterialDark, dark: .regular))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.4,
                radius: 24
            )
        )
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.roundCorners = .all(radius: 25)
        attributes.entranceAnimation = .init(
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.3,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            fade: .init(from: 0, to: 1, duration: 0.3)
        )
        attributes.exitAnimation = .init(
            fade: .init(from: 1, to: 0, duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                fade: .init(from: 1, to: 0, duration: 0.3)
            )
        )
        attributes.positionConstraints.verticalOffset = 10
        attributes.positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(width: .intrinsic, height: .intrinsic)
        attributes.statusBar = .inferred
        return attributes
    }

    static func bottomSheetAttributes(level: UIWindow.Level) -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.windowLevel = .custom(level: level)
        attributes.displayDuration = .infinity
        attributes.entryBackground = .clear
        attributes.screenBackground = .visualEffect(style: .init(light: .systemUltraThinMaterialDark, dark: .regular))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.4,
                radius: 24
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .top(radius: 20)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.3,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3)
            )
        )
        attributes.positionConstraints.size = .init(
            width: .fill,
            height: .intrinsic
        )
        attributes.positionConstraints.verticalOffset = -100
        attributes.positionConstraints.safeArea = .overridden
        attributes.statusBar = .inferred
        return attributes
    }

    static func bottomAlertAttributes(level: UIWindow.Level) -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.windowLevel = .custom(level: level)
        attributes.displayDuration = .infinity
        attributes.entryBackground = .clear
        attributes.screenBackground = .visualEffect(style: .init(light: .systemUltraThinMaterialDark, dark: .regular))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.4,
                radius: 24
            )
        )
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: false,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 20)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.3,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3)
            )
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.size = .init(width: .offset(value: 12), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.width),
            height: .intrinsic
        )
        attributes.statusBar = .inferred
        return attributes
    }

    static func bottomInfoAttributes(level: UIWindow.Level) -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.windowLevel = .custom(level: level)
        attributes.displayDuration = .infinity
        attributes.entryBackground = .clear
        attributes.screenBackground = .visualEffect(style: .init(light: .systemUltraThinMaterialDark, dark: .regular))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.4,
                radius: 24
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 20)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.3,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3)
            )
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.size = .init(width: .offset(value: 12), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.width),
            height: .intrinsic
        )
        attributes.statusBar = .inferred
        return attributes
    }

    static func reachabilityAlertAttributes(level: UIWindow.Level) -> EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.windowLevel = .custom(level: level)
        attributes.displayDuration = .infinity
        attributes.entryBackground = .clear
        attributes.screenBackground = .clear
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.4,
                radius: 24
            )
        )
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .forward
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 20)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.3,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3)
            )
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.size = .init(width: .offset(value: 12), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.width),
            height: .intrinsic
        )
        attributes.statusBar = .inferred
        return attributes
    }

    static func fullScreenAttributes(level: UIWindow.Level) -> EKAttributes {
        var attributes = EKAttributes.default
        attributes.precedence = .enqueue(priority: .normal)
        attributes.windowLevel = .custom(level: level)
        attributes.displayDuration = .infinity
        attributes.entryBackground = .clear
        attributes.screenBackground = .visualEffect(style: .init(light: .systemUltraThinMaterialDark, dark: .regular))
        attributes.shadow = .none
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.roundCorners = .none
        attributes.entranceAnimation = .init(fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(fade: .init(from: 1, to: 0, duration: 0.3))
        attributes.popBehavior = .animated(
            animation: .init(fade: .init(from: 1, to: 0, duration: 0.3))
        )
        attributes.positionConstraints.size = .screen
        attributes.position = .center
        attributes.statusBar = .inferred
        return attributes
    }

    static func pinOverlayAttributes(level: UIWindow.Level) -> EKAttributes {
        var attributes = EKAttributes.default
        attributes.precedence = .enqueue(priority: .normal)
        attributes.windowLevel = .custom(level: level)
        attributes.displayDuration = .infinity
        attributes.entryBackground = .clear
        attributes.screenBackground = .visualEffect(style: .init(light: .systemUltraThinMaterialDark, dark: .regular))
        attributes.shadow = .none
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.roundCorners = .none
        attributes.entranceAnimation = .init(
            translate: .init(duration: 0.2),
            fade: .init(from: 0, to: 1, duration: 0.2)
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2),
            fade: .init(from: 1, to: 0, duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(fade: .init(from: 1, to: 0, duration: 0.2))
        )
        attributes.positionConstraints.size = .screen
        attributes.position = .center
        attributes.statusBar = .inferred
        return attributes
    }

    static func bottomSnackbarAttributes(level: UIWindow.Level, duration: Double = 4.0) -> EKAttributes {
        var attributes = EKAttributes.bottomToast
        attributes.precedence = .enqueue(priority: .normal)
        attributes.windowLevel = .custom(level: level)
        attributes.displayDuration = .init(duration)
        attributes.entryBackground = .clear
        attributes.screenBackground = .clear
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.4,
                radius: 24
            )
        )
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 20)
        attributes.entranceAnimation = .init(fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(fade: .init(from: 1, to: 0, duration: 0.3))
        attributes.popBehavior = .animated(
            animation: .init(
                fade: .init(from: 1, to: 0, duration: 0.3)
            )
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.size = .init(width: .offset(value: 16), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.width),
            height: .intrinsic
        )
        attributes.statusBar = .inferred
        return attributes
    }
}
// swiftlint:enable all
