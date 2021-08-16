//
//  MusicPlayerLyricsViewModel.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/07/03.
//

import Foundation
import Combine

public final class MusicPlayerLyricsViewModel: ObservableObject {
    @Published public private(set) var lyrics: Lyrics?

    private let lyricsSubject = CurrentValueSubject<Lyrics?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    public init() {
        lyricsSubject
            .removeDuplicates()
            .assign(to: \.lyrics, on: self)
            .store(in: &cancellables)
    }

    // MARK: Input

    public func setLyricRawString(_ lyric: String?) {
        let lyrics = Lyrics(rawData: lyric)
        lyricsSubject.send(lyrics)
    }
}
