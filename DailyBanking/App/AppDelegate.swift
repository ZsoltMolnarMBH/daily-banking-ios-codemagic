//
//  AppDelegate.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 10. 15..
//


// :)

import UIKit
import Firebase
import FirebaseRemoteConfig
import FirebaseCore
import Resolver
import DesignKit
import Confy

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var app: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard !isRunningTests() else { return true }

        setupFrameworks()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        app = Coordinator.make(
            using: .root,
            assembly: AppAssembly(), initializer: { container in
                AppCoordinator(container: container)
            })
        app.start(context: window)

        DesignKitModule.configue(analytics: Resolver.resolve(DesignKit.AnalyticsInterface.self))

        return true
    }

    private func setupFrameworks() {
        FirebaseApp.configure()
        #if DEVELOPMENT
        Performance.sharedInstance().isInstrumentationEnabled = false
        Performance.sharedInstance().isDataCollectionEnabled = false
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        #endif
        #if DEBUG
        Confy.settings.persistence.restoreOverrides = true
        #endif
    }
}

#if DEBUG
extension UIWindow {
    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            DebugMenu.open()
        }
    }
}
#endif
