//
//  SubsequentControl.swift
//  SwiftUIMusicPlayer
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct SubsequentControl: View {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image("forward.end")
        })
    }
}

struct SubsequentControl_Previews: PreviewProvider {
    static var previews: some View {
        SubsequentControl(action: {})
    }
}
