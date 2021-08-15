//
//  MusicPlayerLyricViewModel.swift
//  UIKitApp
//
//  Created by Presto on 2021/07/03.
//

import Foundation
import Combine

final class MusicPlayerLyricViewModel: ObservableObject {
    @Published private(set) var lyrics: Lyrics?

    private let lyricsSubject = CurrentValueSubject<Lyrics?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    init() {
        lyricsSubject
            .assign(to: \.lyrics, on: self)
            .store(in: &cancellables)
    }

    func setLyricRawString(_ lyric: String?) {
        let lyrics = Lyrics(response: lyric)
        lyricsSubject.send(lyrics)
    }
}
