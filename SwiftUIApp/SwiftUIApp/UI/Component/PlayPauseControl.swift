//
//  PlayPauseControl.swift
//  SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct PlayPauseControl: View {
    enum Status: String {
        case play
        case pause
    }

    @State private var status: Status = .pause
    private var action: () -> Void

    init(action: @escaping () -> Void, initialStatus: Status = .pause) {
        self.action = action
        self.status = initialStatus
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image({
                switch status {
                case .play:
                    return "pause"
                case .pause:
                    return "play"
                }
            }())
        })
    }
}

struct PlayPauseControl_Previews: PreviewProvider {
    static var previews: some View {
        PlayPauseControl(action: {})
    }
}
