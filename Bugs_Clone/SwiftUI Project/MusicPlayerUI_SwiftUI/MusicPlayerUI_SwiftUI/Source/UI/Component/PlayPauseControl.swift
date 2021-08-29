//
//  PlayPauseControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine
import MusicPlayerCommon

struct PlayPauseControl: View, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> {
        fatalError("Use `action` in initializer instead.")
    }

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

    // MARK: MusicControlComponentProtocol

    func setNextMode(animated: Bool) {
        switch mode {
        case .play:
            self.mode = .pause
        case .pause:
            self.mode = .play
        }

        if animated {

        }
    }
}

// MARK: - Preview

struct PlayPauseControl_Previews: PreviewProvider {
    static var previews: some View {
        PlayPauseControl(action: {})
    }
}
