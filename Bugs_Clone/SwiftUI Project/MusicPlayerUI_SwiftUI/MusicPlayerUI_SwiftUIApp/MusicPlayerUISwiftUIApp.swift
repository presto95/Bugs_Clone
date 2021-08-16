//
//  MusicPlayerUI_SwiftUIApp.swift
//  MusicPlayerUI_SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import WalkmanContentsProvider

@main
struct SwiftUIMusicPlayerApp: App {
    init() {
        // MARK: API Environment Setting
        APIEnvironment.shared.version = .production
    }

    var body: some Scene {
        WindowGroup {
            let viewModel = MusicPlayerViewModel()
            MusicPlayerView(viewModel: viewModel)
        }
    }
}
