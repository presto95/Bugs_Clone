//
//  MusicPlayerBottomView.swift
//  SwiftUIMusicPlayer
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct MusicPlayerBottomView: View {
    @ObservedObject private var viewModel: MusicPlayerBottomViewModel

    init(viewModel: MusicPlayerBottomViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            seekbar

            timeView
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))

            songInfoView

            musicControlView
        }
        .frame(width: .infinity)
    }
}

private extension MusicPlayerBottomView {
    var seekbar: some View {
        Seekbar(currentTime: $viewModel.currentTime, endTime: $viewModel.endTime)
    }

    var timeView: some View {
        HStack {
            Text(viewModel.currentTimeString ?? "")
                .foregroundColor(.primary)
                .font(.footnote)

            Spacer()

            Text(viewModel.endTimeString ?? "")
                .foregroundColor(.primary)
                .font(.footnote)
        }
    }

    var songInfoView: some View {
        VStack(alignment: .center, spacing: .zero) {
            Text(viewModel.title ?? "")
                .foregroundColor(.primary)
                .font(.headline)

            Text(viewModel.album ?? "")
                .foregroundColor(.primary)
                .font(.footnote)
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))

            Text(viewModel.artist ?? "")
                .foregroundColor(.primary)
                .font(.footnote)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
        }
    }

    var musicControlView: some View {
        MusicControlView()
            .repeatCntrolAction {

            }
            .precedentControlAction {

            }
            .playPauseControlAction {

            }
            .subsequentControlAction {

            }
            .shuffleControlAction {

            }
    }
}

struct MusicPlayerBottomView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerBottomView(viewModel: MusicPlayerBottomViewModel())
    }
}
