//
//  UIKitAppDelegate.swift
//  UIKitApp
//
//  Created by Presto on 2021/07/02.
//

import UIKit
import UIKitMusicPlayer
import WalkmanContentsProvider

@main
final class UIKitAppDelegate: UIResponder, UIApplicationDelegate {
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
        let navigationController = UINavigationController(rootViewController: viewController).then {
            $0.setNavigationBarHidden(true, animated: false)
        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        viewController.view.layoutIfNeeded()

        return true
    }
}
