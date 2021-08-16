//
//  MusicPlayerLyricsView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct MusicPlayerLyricsView: View {
    @ObservedObject private var viewModel: MusicPlayerLyricsViewModel

    init(viewModel: MusicPlayerLyricsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if let lyrics = viewModel.lyrics {
            List(0 ..< lyrics.count) { index in
                let lyric = lyrics.lyric(at: index)
                Text(lyric ?? "")
            }
        } else {
            Text("No Lyrics")
        }
    }
}

// MARK: - Preview

struct MusicPlayerLyricsView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerLyricsView(viewModel: MusicPlayerLyricsViewModel())
    }
}
