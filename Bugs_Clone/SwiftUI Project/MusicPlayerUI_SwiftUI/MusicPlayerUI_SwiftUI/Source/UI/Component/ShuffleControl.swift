//
//  ShuffleControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine
import MusicPlayerCommon

struct ShuffleControl: View, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> {
        fatalError("Use `action` in initializer instead.")
    }

    private var action: () -> Void
    @State private var mode: ShuffleMode = .off

    init(action: @escaping () -> Void, initialMode: ShuffleMode = .off) {
        self.action = action
        self.mode = initialMode
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "shuffle")
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
        .opacity({
            switch mode {
            case .off:
                return 0.4
            case .on:
                return 1
            }
        }())
    }

    // MARK: MusicControlComponentProtocol

    func setNextMode(animated: Bool) {
        switch mode {
        case .off:
            self.mode = .on
        case .on:
            self.mode = .off
        }

        if animated {
            
        }
    }
}

struct ShuffleControl_Previews: PreviewProvider {
    static var previews: some View {
        ShuffleControl(action: {})
    }
}
