//
//  MusicPlayerTopViewModel.swift
//  SwiftUIMusicPlayer
//
//  Created by Presto on 2021/08/15.
//

import Combine
import MusicPlayerCommon

final class MusicPlayerTopViewModel: ObservableObject {
    @Published private(set) var displayingInfo: DisplayingInfo = .albumCover

    var albumCoverViewModel: MusicPlayerAlbumCoverViewModel?
    var lyricViewModel: MusicPlayerLyricsViewModel?

    private var cancellables = Set<AnyCancellable>()

    init() {

    }

    func setAlbumCoverImageData(_ data: Data?) {
        albumCoverViewModel?.setAlbumCoverImageData(data)
    }

    func setLyricsRawString(_ lyrics: String?) {
        lyricViewModel?.setLyricRawString(lyrics)
    }

    func setNextDisplayingInfo() {
        switch displayingInfo {
        case .albumCover:
            displayingInfoSubject.send(.lyric)
        case .lyric:
            displayingInfoSubject.send(.albumCover)
        }
    }
}
