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
    @Binding private var modeChangeTrigger: Void?
    private var onModeChanged: ((PlayPauseMode) -> Void)?

    @State private var mode: PlayPauseMode

    init(action: @escaping () -> Void, modeChangeTrigger: Binding<Void?>, initialMode: PlayPauseMode = .pause) {
        self.action = action
        self._modeChangeTrigger = modeChangeTrigger
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
        .onReceive(Just(modeChangeTrigger)) { output in
            guard output != nil else { return }

            switch mode {
            case .pause:
                mode = .play
            case .play:
                mode = .pause
            }

            onModeChanged?(mode)
        }
    }

    @discardableResult
    func action(_ action: @escaping () -> Void) -> Self {
        var `self` = self
        self.action = action
        return self
    }

    @discardableResult
    func modeChangeTrigger(_ trigger: Binding<Void?>) -> Self {
        var `self` = self
        self._modeChangeTrigger = trigger
        return self
    }

    @discardableResult
    func initialMode(_ initialMode: PlayPauseMode) -> Self {
        self.mode = initialMode
        return self
    }

    @discardableResult
    func onModeChanged(_ action: @escaping (PlayPauseMode) -> Void) -> Self {
        var `self` = self
        self.onModeChanged = onModeChanged
        return self
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
        PlayPauseControl(action: {}, modeChangeTrigger: .constant(nil))
            .frame(width: 50, height: 50)
    }
}
