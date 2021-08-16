//
//  MusicPlayerView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine

public struct MusicPlayerView: View {
    @ObservedObject private var viewModel: MusicPlayerViewModel
    @State private var displayingInfo: MusicPlayerDisplayingInfo = .albumCover

    public init(viewModel: MusicPlayerViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack {
            topView
                .frame(height: UIScreen.main.bounds.width)

            bottomView
        }
        .frame(width: .infinity, height: .infinity)
    }
}

private extension MusicPlayerView {
    @ViewBuilder var topView: some View {
        let viewModel = MusicPlayerTopViewModel()
        MusicPlayerTopView(viewModel: viewModel, displayingInfo: $displayingInfo)
    }

    @ViewBuilder var bottomView: some View {
        let viewModel = MusicPlayerBottomViewModel()
        MusicPlayerBottomView(viewModel: viewModel)
    }
}

// MARK: - Preview

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView(viewModel: MusicPlayerViewModel())
    }
}
