//
//  ShuffleControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import MusicPlayerCommon

struct ShuffleControl: View {
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
}

struct ShuffleControl_Previews: PreviewProvider {
    static var previews: some View {
        ShuffleControl(action: {})
    }
}
