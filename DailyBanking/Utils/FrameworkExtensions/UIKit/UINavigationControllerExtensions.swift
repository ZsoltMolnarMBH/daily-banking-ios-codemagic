//
//  UINavigationController+.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 16..
//

import UIKit

extension UINavigationController {
    func pushWithCrossfade(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        pushViewController(viewController, animated: false)
        view.layer.add(transition, forKey: nil)
    }

    func popWithCrossfade(to viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        popToViewController(viewController, animated: false)
        view.layer.add(transition, forKey: nil)
    }

    func setViewControllersWithCrossfade(_ viewControllers: [UIViewController]) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        setViewControllers(viewControllers, animated: false)
        view.layer.add(transition, forKey: nil)
    }

    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var stack = viewControllers
        if stack.count > 0 {
            stack[stack.count - 1] = viewController
        } else {
            stack = [viewController]
        }
        setViewControllers(stack, animated: animated)
    }

    func replaceTopViewControllerWithCrossfade(_ viewController: UIViewController, animated: Bool) {
        var stack = viewControllers
        if stack.count > 0 {
            stack[stack.count - 1] = viewController
        } else {
            stack = [viewController]
        }
        setViewControllersWithCrossfade(stack)
    }
}
