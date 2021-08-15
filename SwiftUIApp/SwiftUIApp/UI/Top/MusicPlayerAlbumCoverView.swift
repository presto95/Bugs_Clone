//
//  MusicPlayerAlbumCoverView.swift
//  SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct MusicPlayerAlbumCoverView: View {
    @ObservedObject private var viewModel: MusicPlayerAlbumCoverViewModel

    init(viewModel: MusicPlayerAlbumCoverViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if let albumCoverImageData = viewModel.albumCoverImageData,
           let uiImage = UIImage(data: albumCoverImageData) {
            Image(uiImage: uiImage)
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct MusicPlayerAlbumCoverView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerAlbumCoverView(viewModel: MusicPlayerAlbumCoverViewModel())
    }
}
