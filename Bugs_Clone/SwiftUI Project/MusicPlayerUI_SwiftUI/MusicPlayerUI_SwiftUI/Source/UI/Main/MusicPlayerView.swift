//
//  MusicPlayerView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine
import MusicPlayerCommon
import Common

public struct MusicPlayerView: View {
    @ObservedObject private var viewModel: MusicPlayerViewModel
    @ObservedObject private var topViewModel: MusicPlayerTopViewModel
    @ObservedObject private var bottomViewModel: MusicPlayerBottomViewModel

    public init(viewModel: MusicPlayerViewModel) {
        self.viewModel = viewModel
        self.topViewModel = viewModel.topViewModel
        self.bottomViewModel = viewModel.bottomViewModel

//        DIContainer.shared.register(self, as: <#T##Dependency.Type#>)
    }

    public var body: some View {
        ZStack(alignment: .center) {
            backgroundView

            VStack(alignment: .center, spacing: .zero) {
                topView
                    .frame(maxWidth: .infinity)
                    .frame(height: {
                        switch topViewModel.displayingInfo {
                        case .albumCover:
                            return UIScreen.main.bounds.width
                        case .lyric:
                            return UIScreen.main.bounds.height * 0.62
                        }
                    }())

                bottomView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension MusicPlayerView {
    @ViewBuilder var backgroundView: some View {
        if let albumCoverImageData = viewModel.albumCoverImageData,
           let uiImage = UIImage(data: albumCoverImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ViewBuilder var topView: some View {
        MusicPlayerTopView(viewModel: viewModel.topViewModel)
    }

    @ViewBuilder var bottomView: some View {
        MusicPlayerBottomView(viewModel: viewModel.bottomViewModel)
    }
}

// MARK: - Preview

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView(viewModel: MusicPlayerViewModel())
    }
}
