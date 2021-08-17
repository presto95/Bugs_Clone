//
//  MusicPlayerTopView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct MusicPlayerTopView: View {
    @ObservedObject private var viewModel: MusicPlayerTopViewModel

    init(viewModel: MusicPlayerTopViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            switch viewModel.displayingInfo {
            case .albumCover:
                albumCoverView
            case .lyric:
                lyricsView
            }
        }
        .onTapGesture {
            viewModel.setNextDisplayingInfo()
        }
    }
}

private extension MusicPlayerTopView {
    @ViewBuilder var albumCoverView: some View {
        let viewModel = MusicPlayerAlbumCoverViewModel()
        MusicPlayerAlbumCoverView(viewModel: viewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder var lyricsView: some View {
        let viewModel = MusicPlayerLyricsViewModel()
        MusicPlayerLyricsView(viewModel: viewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

struct MusicPlayerTopView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerTopView(viewModel: MusicPlayerTopViewModel())
    }
}
