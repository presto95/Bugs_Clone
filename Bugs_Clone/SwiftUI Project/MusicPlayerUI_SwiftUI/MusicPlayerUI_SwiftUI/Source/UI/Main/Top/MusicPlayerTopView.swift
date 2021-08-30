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
    @ObservedObject private var albumCoverViewModel: MusicPlayerAlbumCoverViewModel
    @ObservedObject private var lyricsViewModel: MusicPlayerLyricsViewModel

    init(viewModel: MusicPlayerTopViewModel) {
        self.viewModel = viewModel
        self.albumCoverViewModel = viewModel.albumCoverViewModel
        self.lyricsViewModel = viewModel.lyricsViewModel
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            viewModel.setNextDisplayingInfo()
        }
    }
}

private extension MusicPlayerTopView {
    @ViewBuilder var albumCoverView: some View {
        MusicPlayerAlbumCoverView(viewModel: viewModel.albumCoverViewModel)
    }

    @ViewBuilder var lyricsView: some View {
        MusicPlayerLyricsView(viewModel: viewModel.lyricsViewModel)
    }
}

// MARK: - Preview

struct MusicPlayerTopView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerTopView(viewModel: MusicPlayerTopViewModel())
    }
}
