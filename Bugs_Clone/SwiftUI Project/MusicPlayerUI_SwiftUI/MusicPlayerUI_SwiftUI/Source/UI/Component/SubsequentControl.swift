//
//  SubsequentControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI
import Combine
import MusicPlayerCommon

struct SubsequentControl: View, MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> {
        fatalError("Use `action` in initializer instead.")
    }

    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "forward.end")
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }

    @discardableResult
    func action(_ action: @escaping () -> Void) -> Self {
        var `self` = self
        self.action = action
        return self
    }

    // MARK: MusicControlComponentProtocol

    func setNextMode(animated: Bool) {
        if animated {

        }
    }
}

// MARK: - Preview

struct SubsequentControl_Previews: PreviewProvider {
    static var previews: some View {
        SubsequentControl(action: {})
            .frame(width: 50, height: 50)
    }
}
