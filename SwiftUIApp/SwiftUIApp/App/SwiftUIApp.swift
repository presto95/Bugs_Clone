//
//  SwiftUIApp.swift
//  SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import WalkmanContentsProvider
import Then

@main
struct SwiftUIApp: App {
    init() {
        // MARK: API Environment Setting
        APIEnvironment.shared.version = .production
    }

    var body: some Scene {
        WindowGroup {
            MusicPlayerView()
        }
    }
}
