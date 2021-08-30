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
    @Binding private var modeChangeTrigger: Void?
    private var onModeChanged: ((RepeatMode) -> Void)?

    @State private var mode: RepeatMode

    init(action: @escaping () -> Void, modeChangeTrigger: Binding<Void?>, initialMode: RepeatMode = .off) {
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
                case .off:
                    return "repeat"
                case .one:
                    return "repeat.1"
                }
            }())
            .resizable()
            .aspectRatio(contentMode: .fit)
        })
        .onReceive(Just(modeChangeTrigger)) { output in
            guard output != nil else { return }
            
            switch mode {
            case .off:
                mode = .one
            case .one:
                mode = .off
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
    func initialMode(_ initialMode: RepeatMode) -> Self {
        self.mode = initialMode
        return self
    }

    @discardableResult
    func onModeChanged(_ action: @escaping (RepeatMode) -> Void) -> Self {
        var `self` = self
        self.onModeChanged = action
        return self
    }

    // MARK: MusicControlComponentProtocol

    func setNextMode(animated: Bool) {
        switch mode {
        case .off:
            self.mode = .one
        case .one:
            self.mode = .off
        }
    }
}

// MARK: - Preview

struct RepeatControl_Previews: PreviewProvider {
    static var previews: some View {
        RepeatControl(action: {}, modeChangeTrigger: .constant(nil))
            .frame(width: 50, height: 50)
    }
}
