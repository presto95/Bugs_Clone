//
//  ShuffleControl.swift
//  SwiftUIMusicPlayer
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct ShuffleControl: View {
    enum Status: String {
        case off
        case on
    }

    private var action: () -> Void
    @State private var status: Status = .off

    init(action: @escaping () -> Void, initialStatus: Status = .off) {
        self.action = action
        self.status = initialStatus
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image("shuffle")
        })
        .opacity({
            switch status {
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
