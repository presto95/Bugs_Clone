//
//  BugsCloneSwiftUIApp.swift
//  Bugs_Clone_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerUI_SwiftUI
import WalkmanContentsProvider

@main
struct BugsCloneSwiftUIApp: App {
    init() {
        // MARK: API Environment Setting
        APIEnvironment.shared.version = .production
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                let viewModel = MusicPlayerViewModel()
                MusicPlayerView(viewModel: viewModel)
            }
            .accentColor(.primary)
        }
    }
}
