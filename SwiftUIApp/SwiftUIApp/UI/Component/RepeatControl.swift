//
//  RepeatControl.swift
//  SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct RepeatControl: View {
    enum Status: String {
        case off
        case one
    }

    @State private var status: Status = .off
    private var action: () -> Void

    init(action: @escaping () -> Void, initialStatus: Status = .off) {
        self.action = action
        self.status = initialStatus
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image({
                switch status {
                case .off:
                    return "repeat"
                case .one:
                    return "repeat.1"
                }
            }())
        })
    }

    func setNextStatus(animated: Bool) {
        switch status {
        case .off:
            self.status = .one
        case .one:
            self.status = .off
        }

        if animated {

        }
    }
}
