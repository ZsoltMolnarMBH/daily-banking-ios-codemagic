//
//  BaseTestCase.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 11. 19..
//

import XCTest
import Resolver
@testable import DailyBanking

class BaseTestCase: XCTestCase {

    var container: Resolver!

    /// Use this for additional mock service registrations into the `app` container,
    /// since the app container is always created.
    /// - Parameter container: DI container of the `AppCoordinator`
    func assembleAppContainer(container: Resolver) { }

    /// Order of `setUp` and `tearDown` functions
    /// https://developer.apple.com/documentation/xctest/xctestcase/understanding_setup_and_teardown_for_test_methods

    override func setUpWithError() throws {
        appDelegate.app = Coordinator.make(
            using: .root,
            assembly: AppAssembly(), initializer: { container in
                // Perform shared app container overrides for mocking
                AppAssemblyMock().assemble(container: container)
                // Perform test case specific app container overrides for mocking
                assembleAppContainer(container: container)
                return AppCoordinator(container: container)
            })
    }

    override func tearDownWithError() throws {
        let newRoot = Resolver()
        Resolver.main = newRoot
        Resolver.root = newRoot
        if let container = container {
            container.cache.reset()
        }
        container = nil
    }

    var appDelegate: AppDelegate {
        // swiftlint:disable:next force_cast
        return UIApplication.shared.delegate as! AppDelegate
    }

    var appCoordiantor: AppCoordinator {
        return appDelegate.app
    }

    func makeMainContainer() -> Resolver {
        return appCoordiantor
            .container
            .makeChild()
            .assembled(using: MainAssembly())
    }
}
