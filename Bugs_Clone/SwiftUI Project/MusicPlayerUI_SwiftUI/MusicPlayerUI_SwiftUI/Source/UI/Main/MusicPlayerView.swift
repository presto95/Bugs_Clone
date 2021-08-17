//
//  MusicPlayerView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine
import MusicPlayerCommon

public struct MusicPlayerView: View {
    @ObservedObject private var viewModel: MusicPlayerViewModel
    @State private var displayingInfo: DisplayingInfo = .albumCover

    public init(viewModel: MusicPlayerViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack(alignment: .center) {
            Image("")
                .resizable()
                .background(Color.green)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(alignment: .center, spacing: .zero) {
                topView
                    .frame(maxWidth: .infinity)
                    .frame(height: {
                        switch displayingInfo {
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
    @ViewBuilder var topView: some View {
        let viewModel = MusicPlayerTopViewModel()
        MusicPlayerTopView(viewModel: viewModel)
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
