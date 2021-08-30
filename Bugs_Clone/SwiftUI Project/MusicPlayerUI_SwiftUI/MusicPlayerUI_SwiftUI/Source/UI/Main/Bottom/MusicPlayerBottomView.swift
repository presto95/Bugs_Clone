//
//  MusicPlayerBottomView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct MusicPlayerBottomView: View {
    @AppStorage(UserDefaults.Key.lastRepeatMode) var lastRepeatMode: String?
    @AppStorage(UserDefaults.Key.lastShuffleMode) var lastShuffleMode: String?
    @ObservedObject private var viewModel: MusicPlayerBottomViewModel

    @State private var playPauseMode: PlayPauseMode = .pause

    init(viewModel: MusicPlayerBottomViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            seekbar
                .frame(height: 8)

            timeView
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))

            VStack(alignment: .center, spacing: .zero) {
                songInfoView
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                musicControlView
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                //                    .frame(height: UIScreen.main.bounds.width / 10)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension MusicPlayerBottomView {
    @ViewBuilder var seekbar: some View {
        Seekbar(currentTime: $viewModel.currentTimeInSeconds, endTime: $viewModel.endTimeInSeconds)
    }

    @ViewBuilder var timeView: some View {
        HStack {
            Text(viewModel.currentTime ?? "")
                .foregroundColor(.primary)
                .font(.footnote)

            Spacer()

            Text(viewModel.endTime ?? "")
                .foregroundColor(.primary)
                .font(.footnote)
        }
    }

    @ViewBuilder var songInfoView: some View {
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

    @ViewBuilder var musicControlView: some View {
        MusicControlView()
            .repeatControlConfiguration { repeatControl in
                repeatControl
                    .action {

                    }
                    .modeChangeTrigger(.constant(nil))
                    .initialMode(RepeatMode(rawValue: self.lastRepeatMode ?? "") ?? .off)
                    .onModeChanged { repeatMode in

                    }

            }
            .precedentControlConfiguration { precedentControl in
                precedentControl
                    .action {

                    }
            }
            .playPauseControlConfiguration { playPauseControl in
                playPauseControl
                    .action {

                    }
                    .modeChangeTrigger(.constant(nil))
                    .initialMode(.pause)
                    .onModeChanged { playPauseMode in

                    }
            }
            .subsequentControlConfiguration { subsequentControl in
                subsequentControl
                    .action {

                    }
            }
            .shuffleControlConfiguration { shuffleControl in
                shuffleControl
                    .action {

                    }
                    .modeChangeTrigger(.constant(nil))
                    .initialMode(ShuffleMode(rawValue: self.lastShuffleMode ?? "") ?? .off)
                    .onModeChanged { shuffleMode in
                        
                    }
            }
    }
}

// MARK: - Preview

struct MusicPlayerBottomView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerBottomView(viewModel: MusicPlayerBottomViewModel())
    }
}
