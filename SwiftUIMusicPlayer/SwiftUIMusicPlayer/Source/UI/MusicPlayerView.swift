//
//  MusicPlayerView.swift
//  SwiftUIMusicPlayer
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine

public struct MusicPlayerView: View {
    @ObservedObject private var viewModel: MusicPlayerViewModel

    public init(viewModel: MusicPlayerViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

// MARK: - Preview

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView(viewModel: MusicPlayerViewModel())
    }
}
