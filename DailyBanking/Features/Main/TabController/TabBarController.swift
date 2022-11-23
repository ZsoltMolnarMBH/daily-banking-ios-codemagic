//
//  TabBarController.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 11. 12..
//

import SwiftUI
import UIKit
import DesignKit
import Resolver

class TabBarController: UITabBarController {
    @Injected(container: .root) var analytics: ViewAnalyticsInterface
    var shouldSelect: ((UIViewController) -> Bool)?
    var isSelectionDisabled: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance(for: traitCollection)

        delegate = self
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        analytics.logButtonPress(contentType: "bottom navigation", componentLabel: item.title ?? "")
    }

    private func setAppearance(for traitCollection: UITraitCollection) {
        let blurred = UITabBarAppearance()
        blurred.configureWithDefaultBackground()
        let transparent = UITabBarAppearance()
        transparent.configureWithTransparentBackground()

        if traitCollection.userInterfaceStyle == .light {
            transparent.backgroundColor = UIColor(DesignKit.Colors.grey50)
            view.backgroundColor = UIColor(DesignKit.Colors.grey50)
            tabBar.tintColor = UIColor(DesignKit.Colors.action600)
        } else {
            transparent.backgroundColor = UIColor(DesignKit.Colors.grey950)
            view.backgroundColor = UIColor(DesignKit.Colors.grey950)
            tabBar.tintColor = UIColor(DesignKit.Colors.action300)
        }

        setTabBarItemAppearance(of: blurred)
        setTabBarItemAppearance(of: transparent)

        tabBar.standardAppearance = blurred
        tabBar.scrollEdgeAppearance = transparent

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: TextStyle.headings7.uiFont], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: TextStyle.headings7.uiFont], for: .selected)
    }

    private func setTabBarItemAppearance(of appearance: UITabBarAppearance) {
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)
    }

    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        let unselected: UIColor
        let selected: UIColor
        if traitCollection.userInterfaceStyle == .light {
            unselected = UIColor(DesignKit.Colors.grey600)
            selected = UIColor(DesignKit.Colors.action600)
        } else {
            unselected = UIColor(DesignKit.Colors.grey300)
            selected = UIColor(DesignKit.Colors.action300)
        }

        itemAppearance.normal.iconColor = unselected
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: unselected]
        itemAppearance.selected.iconColor = selected
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selected]
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setAppearance(for: traitCollection)
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let direction = animationDirection(from: fromVC, to: toVC)
        isSelectionDisabled = true
        return TabBarAnimatedTransitioning(direction: direction) { [weak self] in
            self?.isSelectionDisabled = false
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard !isSelectionDisabled else { return false }
        if viewController == tabBarController.selectedViewController {
            NotificationCenter.default.post(name: .reselectTab, object: viewController.tabBarItem.name)
        }
        return shouldSelect?(viewController) ?? true
    }

    private func index(of viewController: UIViewController) -> Int? {
        viewControllers?.firstIndex { $0 == viewController }
    }

    private func animationDirection(from fromVC: UIViewController, to toVC: UIViewController) -> TabBarAnimatedTransitioning.Direction {
        guard let from = index(of: fromVC),
              let destination = index(of: toVC),
              from != destination else { return .none }
        return from < destination ? .right : .left
    }
}

private class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    enum Direction {
        case left, right, none

        var modifier: CGFloat {
            switch self {
            case .left:
                return -1
            case .right:
                return 1
            case .none:
                return 0
            }
        }
    }

    private let direction: Direction
    private let completion: () -> Void
    private var offset: CGFloat {
        (UIScreen.main.bounds.width / 8) * direction.modifier
    }

    init(direction: Direction, completion: @escaping () -> Void) {
        self.direction = direction
        self.completion = completion
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let starting = transitionContext.view(forKey: .from),
              let destination = transitionContext.view(forKey: .to) else { return transitionContext.completeTransition(false) }

        destination.alpha = 0.0
        destination.transform = .init(translationX: offset, y: 0)
        transitionContext.containerView.addSubview(destination)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                destination.alpha = 1.0
                starting.alpha = 0.0
                starting.transform = .init(translationX: self.offset * -1, y: 0)
                destination.transform = .identity
            }, completion: {
                starting.transform = .identity
                starting.alpha = 1.0
                transitionContext.completeTransition($0)
                self.completion()
            }
        )
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }

}
