//
//  MusicPlayerUIKitAppDelegate.swift
//  MusicPlayerUI_UIKitApp
//
//  Created by Presto on 2021/08/15.
//

import UIKit
import MusicPlayerUI_UIKit
import WalkmanContentsProvider

@main
final class MusicPlayerUIKitAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: API Environment Setting
        APIEnvironment.shared.version = .production

        // MARK: Window
        window = UIWindow()
        window?.tintColor = .label

        // MARK: Root View Controller
        let viewModel = MusicPlayerViewModel()
        let viewController = MusicPlayerViewController(viewModel: viewModel)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        viewController.view.layoutIfNeeded()

        return true
    }
}
