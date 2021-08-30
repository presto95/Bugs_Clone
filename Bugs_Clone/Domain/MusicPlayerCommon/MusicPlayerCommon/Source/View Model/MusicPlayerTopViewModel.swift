//
//  MusicPlayerTopViewModel.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/07/24.
//

import Combine

public final class MusicPlayerTopViewModel: ObservableObject {
    @Published public private(set) var displayingInfo: DisplayingInfo = .albumCover

    private let displayingInfoSubject = CurrentValueSubject<DisplayingInfo, Never>(.albumCover)

    public private(set) var albumCoverViewModel: MusicPlayerAlbumCoverViewModel
    public private(set) var lyricsViewModel: MusicPlayerLyricsViewModel

    private var cancellables = Set<AnyCancellable>()

    public init(albumCoverViewModel: MusicPlayerAlbumCoverViewModel = MusicPlayerAlbumCoverViewModel(),
                lyricsViewModel: MusicPlayerLyricsViewModel = MusicPlayerLyricsViewModel()) {
        self.albumCoverViewModel = albumCoverViewModel
        self.lyricsViewModel = lyricsViewModel

        displayingInfoSubject
            .removeDuplicates()
            .assign(to: \.displayingInfo, on: self)
            .store(in: &cancellables)
    }

    // MARK: Input

    public func setNextDisplayingInfo() {
        switch displayingInfo {
        case .albumCover:
            displayingInfoSubject.send(.lyric)
        case .lyric:
            displayingInfoSubject.send(.albumCover)
        }
    }
}
