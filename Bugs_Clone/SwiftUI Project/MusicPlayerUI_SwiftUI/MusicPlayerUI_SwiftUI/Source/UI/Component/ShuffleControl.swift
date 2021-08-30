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
    @Binding private var modeChangeTrigger: Void?
    private var onModeChanged: ((ShuffleMode) -> Void)?

    @State private var mode: ShuffleMode

    init(action: @escaping () -> Void, modeChangeTrigger: Binding<Void?>, initialMode: ShuffleMode = .off) {
        self.action = action
        self._modeChangeTrigger = modeChangeTrigger
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
        .onReceive(Just(modeChangeTrigger)) { output in
            guard output != nil else { return }

            switch mode {
            case .off:
                mode = .on
            case .on:
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
    func initialMode(_ initialMode: ShuffleMode) -> Self {
        self.mode = initialMode
        return self
    }

    @discardableResult
    func onModeChanged(_ action: @escaping (ShuffleMode) -> Void) -> Self {
        var `self` = self
        self.onModeChanged = onModeChanged
        return self
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
        ShuffleControl(action: {}, modeChangeTrigger: .constant(nil))
            .frame(width: 50, height: 50)
    }
}
