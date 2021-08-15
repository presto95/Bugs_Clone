//
//  MusicPlayerLyricsView.swift
//  SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct MusicPlayerLyricsView: View {
    @ObservedObject private var viewModel: MusicPlayerLyricsViewModel

    init(viewModel: MusicPlayerLyricsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MusicPlayerLyricsView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerLyricsView(viewModel: MusicPlayerLyricsViewModel())
    }
}
