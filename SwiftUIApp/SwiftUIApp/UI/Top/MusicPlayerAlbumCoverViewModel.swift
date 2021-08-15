//
//  MusicPlayerAlbumCoverViewModel.swift
//  SwiftUIApp
//
//  Created by Presto on 2021/08/15.
//

import Foundation
import Combine

final class MusicPlayerAlbumCoverViewModel: ObservableObject {
    @Published private(set) var albumCoverImageData: Data?
}
