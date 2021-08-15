//
//  MusicPlayerTopViewModel.swift
//  UIKitApp
//
//  Created by Presto on 2021/07/24.
//

import Foundation
import Combine

final class MusicPlayerTopViewModel: ObservableObject {
    @Published private(set) var displayingInfo: DisplayingInfo = .albumCover
    @Published private(set) var albumCoverImageData: Data?

    private let displayingInfoSubject = CurrentValueSubject<DisplayingInfo, Never>(.albumCover)
    private let albumCoverImageDataSubject = CurrentValueSubject<Data?, Never>(nil)

    var lyricViewModel: MusicPlayerLyricViewModel?

    private var cancellables = Set<AnyCancellable>()

    init() {
        displayingInfoSubject
            .removeDuplicates()
            .assign(to: \.displayingInfo, on: self)
            .store(in: &cancellables)

        albumCoverImageDataSubject
            .assign(to: \.albumCoverImageData, on: self)
            .store(in: &cancellables)
    }

    func setAlbumCoverImageData(_ data: Data?) {
        albumCoverImageDataSubject.send(data)
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
