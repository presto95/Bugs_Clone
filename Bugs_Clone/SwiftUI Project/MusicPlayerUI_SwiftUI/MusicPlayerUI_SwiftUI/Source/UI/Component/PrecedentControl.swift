//
//  PrecedentControl.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct PrecedentControl: View {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "backward.end")
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }
}

// MARK: - Preview

struct PrecedentControl_Previews: PreviewProvider {
    static var previews: some View {
        PrecedentControl(action: {})
            .frame(width: 50, height: 50)
    }
}
