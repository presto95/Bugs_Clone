//
//  RepeatControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine
import MusicPlayerCommon

struct RepeatControl: View, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> {
        fatalError("Use `action` in initializer instead.")
    }

    private var action: () -> Void
    @Binding private(set) var mode: RepeatMode

    init(action: @escaping () -> Void, mode: Binding<RepeatMode>) {
        self.action = action
        self._mode = mode
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

    // MARK: MusicControlComponentProtocol

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
        RepeatControl(action: {}, mode: .constant(.off))
    }
}
