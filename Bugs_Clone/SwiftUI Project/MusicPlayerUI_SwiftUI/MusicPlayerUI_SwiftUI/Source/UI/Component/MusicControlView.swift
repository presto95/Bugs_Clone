//
//  MusicControlView.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct MusicControlView: View {
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            repeatControl

            Spacer()

            precedentControl

            Spacer()

            playPauseControl

            Spacer()

            subsequentControl

            Spacer()

            shuffleControl
        }
        .frame(maxWidth: .infinity)
    }
}

extension MusicControlView {
    func repeatControlConfiguration(_ configuration: (RepeatControl) -> Void) -> Self {
        guard let repeatControl = repeatControl as? RepeatControl else { return self }
        configuration(repeatControl)
        return self
    }

    func precedentControlConfiguration(_ configuration: (PrecedentControl) -> Void) -> Self {
        guard let precedentControl = precedentControl as? PrecedentControl else { return self }
        configuration(precedentControl)
        return self
    }

    func playPauseControlConfiguration(_ configuration: (PlayPauseControl) -> Void) -> Self {
        guard let playPauseControl = playPauseControl as? PlayPauseControl else { return self }
        configuration(playPauseControl)
        return self
    }

    func subsequentControlConfiguration(_ configuration: (SubsequentControl) -> Void) -> Self {
        guard let subsequentControl = subsequentControl as? SubsequentControl else { return self }
        configuration(subsequentControl)
        return self
    }

    func shuffleControlConfiguration(_ configuration: (ShuffleControl) -> Void) -> Self {
        guard let shuffleControl = shuffleControl as? ShuffleControl else { return self }
        configuration(shuffleControl)
        return self
    }
}

private extension MusicControlView {
    var repeatControl: some View {
        RepeatControl(action: {}, modeChangeTrigger: .constant(nil))
    }

    var precedentControl: some View {
        PrecedentControl(action: {})
    }

    var playPauseControl: some View {
        PlayPauseControl(action: {}, modeChangeTrigger: .constant(nil))
    }

    var subsequentControl: some View {
        SubsequentControl(action: {})
    }

    var shuffleControl: some View {
        ShuffleControl(action: {}, modeChangeTrigger: .constant(nil))
    }
}

struct MusicControlView_Previews: PreviewProvider {
    static var previews: some View {
        MusicControlView()
            .frame(maxWidth: .infinity, maxHeight: 50)
    }
}
