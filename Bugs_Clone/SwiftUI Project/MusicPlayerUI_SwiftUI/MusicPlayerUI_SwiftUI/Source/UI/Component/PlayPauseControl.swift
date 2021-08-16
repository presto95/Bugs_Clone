//
//  PlayPauseControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct PlayPauseControl: View {
    private var action: () -> Void
    @State private var mode: PlayPauseMode = .pause

    init(action: @escaping () -> Void, initialMode: PlayPauseMode = .pause) {
        self.action = action
        self.mode = initialMode
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: {
                switch mode {
                case .play:
                    return "pause"
                case .pause:
                    return "play"
                }
            }())
            .resizable()
            .aspectRatio(contentMode: .fit)
        })
    }
}

// MARK: - Preview

struct PlayPauseControl_Previews: PreviewProvider {
    static var previews: some View {
        PlayPauseControl(action: {})
    }
}
