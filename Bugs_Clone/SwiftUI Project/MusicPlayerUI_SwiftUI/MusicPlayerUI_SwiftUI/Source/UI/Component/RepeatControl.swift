//
//  RepeatControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct RepeatControl: View {
    private var action: () -> Void
    @State private var mode: RepeatMode = .off

    init(action: @escaping () -> Void, initialMode: RepeatMode = .off) {
        self.action = action
        self.mode = initialMode
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: {
                switch mode {
                case .off:
                    return "repeat"
                case .one:
                    return "repeat.1"
                }
            }())
            .resizable()
            .aspectRatio(contentMode: .fit)
        })
    }

    func setNextMode(animated: Bool) {
        switch mode {
        case .off:
            self.mode = .one
        case .one:
            self.mode = .off
        }

        if animated {

        }
    }
}

// MARK: - Preview

struct RepeatControl_Previews: PreviewProvider {
    static var previews: some View {
        RepeatControl(action: {})
    }
}
