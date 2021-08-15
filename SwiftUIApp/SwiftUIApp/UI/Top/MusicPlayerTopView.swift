//
//  MusicPlayerTopView.swift
//  SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct MusicPlayerTopView: View {
    @ObservedObject private var viewModel: MusicPlayerTopViewModel

    @Binding var displayingInfo: DisplayingInfo

    init(viewModel: MusicPlayerTopViewModel, displayingInfo: Binding<DisplayingInfo>) {
        self.viewModel = viewModel
        self._displayingInfo = displayingInfo
    }

    var body: some View {
        switch displayingInfo {
        case .albumCover:
            let viewModel = MusicPlayerAlbumCoverViewModel()
            MusicPlayerAlbumCoverView(viewModel: viewModel)
        case .lyric:
            let viewModel = MusicPlayerLyricsViewModel()
            MusicPlayerLyricsView(viewModel: viewModel)
        }
    }
}

struct MusicPlayerTopView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerTopView(viewModel: MusicPlayerTopViewModel(),
                           displayingInfo: .constant(.albumCover))
    }
}
