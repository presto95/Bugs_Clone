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

    public var albumCoverViewModel: MusicPlayerAlbumCoverViewModel?
    public var lyricsViewModel: MusicPlayerLyricsViewModel?

    private var cancellables = Set<AnyCancellable>()

    public init() {
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
