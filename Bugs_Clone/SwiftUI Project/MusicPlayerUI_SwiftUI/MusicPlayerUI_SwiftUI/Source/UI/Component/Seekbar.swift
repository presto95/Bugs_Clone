//
//  Seekbar.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct Seekbar: View {
    @State private var isTracking: Bool = false
    @State private var currentTime: TimeInterval = .zero
    @State private var endTime: TimeInterval = .zero

    private var timeUpdatedWithSeekingAction: ((TimeInterval) -> Void)?

    init(currentTime: TimeInterval, endTime: TimeInterval) {
        self.currentTime = currentTime
        self.endTime = endTime
    }

    var body: some View {
        entireTimeBar
            .overlay(currentTimeBar, alignment: .leading)
    }
}

extension Seekbar {
    func timeUpdatedWithSeekingAction(_ action: @escaping (TimeInterval) -> Void) -> Self {
        var `self` = self
        self.timeUpdatedWithSeekingAction = action
        return self
    }
}

private extension Seekbar {
    var entireTimeBar: some View {
        Rectangle()
            .foregroundColor(.gray)
            .gesture(TapGesture().onEnded {

            })
            .gesture(DragGesture().onChanged { state in

            })
            .gesture(LongPressGesture(minimumDuration: 0.1).onChanged { flag in

            })
    }

    var currentTimeBar: some View {
        Rectangle()
            .foregroundColor(.black)
            .gesture(TapGesture().onEnded {

            })
            .gesture(DragGesture().onChanged { state in

            })
            .gesture(LongPressGesture(minimumDuration: 0.1).onChanged { flag in

            })
    }
}

private extension Seekbar {
//    func updateCurrentTimeBar
}

// MARK: - Preview

struct Seekbar_Previews: PreviewProvider {
    static var previews: some View {
        Seekbar(currentTime: 50, endTime: 100)
            .frame(width: UIScreen.main.bounds.width, height: 8)
    }
}
