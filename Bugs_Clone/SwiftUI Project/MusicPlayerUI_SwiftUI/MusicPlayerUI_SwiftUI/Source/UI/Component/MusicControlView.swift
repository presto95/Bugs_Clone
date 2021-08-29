//
//  MusicControlView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct MusicControlView: View {
    @Binding private var repeatMode: RepeatMode
    @Binding private var playPauseMode: PlayPauseMode
    @Binding private var shuffleMode: ShuffleMode

    private var repeatControlAction: (() -> Void)?
    private var precedentControlAction: (() -> Void)?
    private var playPauseControlAction: (() -> Void)?
    private var subsequentControlAction: (() -> Void)?
    private var shuffleControlAction: (() -> Void)?

    init(repeatMode: Binding<RepeatMode>, playPauseMode: Binding<PlayPauseMode>, shuffleMode: Binding<ShuffleMode>) {
        _repeatMode = repeatMode
        _playPauseMode = playPauseMode
        _shuffleMode = shuffleMode
    }

    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            RepeatControl(action: {
                repeatControlAction?()
            }, mode: $repeatMode)

            Spacer()

            PrecedentControl(action: {
                precedentControlAction?()
            })

            Spacer()

            PlayPauseControl(action: {
                playPauseControlAction?()
            }, mode: $playPauseMode)

            Spacer()

            SubsequentControl(action: {
                subsequentControlAction?()
            })

            Spacer()

            ShuffleControl(action: {
                shuffleControlAction?()
            }, mode: $shuffleMode)
        }
        .frame(maxWidth: .infinity)
    }
}

extension MusicControlView {
    func repeatControlAction(_ action: @escaping () -> Void) -> Self {
        var `self` = self
        self.repeatControlAction = action
        return self
    }

    func precedentControlAction(_ action: @escaping () -> Void) -> Self {
        var `self` = self
        self.precedentControlAction = action
        return self
    }

    func playPauseControlAction(_ action: @escaping () -> Void) -> Self {
        var `self` = self
        self.playPauseControlAction = action
        return self
    }

    func subsequentControlAction(_ action: @escaping () -> Void) -> Self {
        var `self` = self
        self.subsequentControlAction = action
        return self
    }

    func shuffleControlAction(_ action: @escaping () -> Void) -> Self {
        var `self` = self
        self.shuffleControlAction = action
        return self
    }
}

struct MusicControlView_Previews: PreviewProvider {
    static var previews: some View {
        MusicControlView(repeatMode: .constant(.off), playPauseMode: .constant(.pause), shuffleMode: .constant(.off))
    }
}
