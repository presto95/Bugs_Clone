//
//  Seekbar.swift
//  SwiftUIMusicPlayer
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct Seekbar: View {
    @Binding var currentTime: TimeInterval
    @Binding var endTime: TimeInterval

    var body: some View {
        entireTimeBar
            .overlay(currentTimeBar, alignment: .leading)
    }
}

private extension Seekbar {
    var entireTimeBar: some View {
        Rectangle()
            .foregroundColor(.gray)
    }

    var currentTimeBar: some View {
        Rectangle()
            .foregroundColor(.black)
    }
}

struct Seekbar_Previews: PreviewProvider {
    static var previews: some View {
        Seekbar(currentTime: .constant(0), endTime: .constant(100))
    }
}
