//
//  AppDelegate.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/02.
//

import UIKit
import Then

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Environment Setting
        MusicAPIEnvironment.shared.version = .production

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
