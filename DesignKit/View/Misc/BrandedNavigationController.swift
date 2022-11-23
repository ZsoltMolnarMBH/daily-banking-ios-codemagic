//
//  BrandedNavigationController.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 25..
//

import UIKit

public class BrandedNavigationController: UINavigationController {

    public convenience init() {
        self.init(rootViewController: UIViewController())
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setAppearance()
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setAppearance() {
        var backButton = UIImage(named: ImageName.backButton.rawValue)
        if traitCollection.userInterfaceStyle == .light {
            backButton = backButton?.withTintColor(UIColor(Colors.action600), renderingMode: .alwaysOriginal)
        } else {
            backButton = backButton?.withTintColor(UIColor(Colors.action300), renderingMode: .alwaysOriginal)
        }
        navigationBar.tintColor = .clear
        navigationBar.backIndicatorImage = backButton
        navigationBar.backIndicatorTransitionMaskImage = backButton
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: TextStyle.headings4.uiFont]
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setAppearance()
        }
    }
}

extension BrandedNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.overrideUserInterfaceStyle != .unspecified {
            navigationController.overrideUserInterfaceStyle = viewController.overrideUserInterfaceStyle
        }
        guard let navigationBarStyle = viewController.navigationBarStyle else { return }
        switch navigationBarStyle {
        case .hidden:
            setNavigationBarHidden(true, animated: true)
        case .inline:
            setNavigationBarHidden(false, animated: true)
            navigationBar.prefersLargeTitles = false
        case .large:
            setNavigationBarHidden(false, animated: true)
            navigationBar.prefersLargeTitles = true
        }
    }
}

private var associateKey: Void?

public extension UIViewController {
    var navigationBarStyle: NavigationBarStyle? {
        get {
            return objc_getAssociatedObject(self, &associateKey) as? NavigationBarStyle
        }
        set {
            objc_setAssociatedObject(self, &associateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public enum NavigationBarStyle {
    case hidden
    case inline
    case large
}
