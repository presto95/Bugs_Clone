//
//  MusicPlayerAlbumCoverView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct MusicPlayerAlbumCoverView: View {
    @ObservedObject private var viewModel: MusicPlayerAlbumCoverViewModel

    init(viewModel: MusicPlayerAlbumCoverViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if let albumCoverImageData = viewModel.albumCoverImageData,
               let uiImage = UIImage(data: albumCoverImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

struct MusicPlayerAlbumCoverView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerAlbumCoverView(viewModel: MusicPlayerAlbumCoverViewModel())
    }
}
