//
//  MusicPlayerViewModel.swift
//  SwiftUIMusicPlayer
//
//  Created by Presto on 2021/08/15.
//

import Foundation
import Combine

public final class MusicPlayerViewModel: ObservableObject {
    @Published private(set) var albumCoverImageData: Data?

    public init() {}
}
