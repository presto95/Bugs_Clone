//
//  MusicPlayerAlbumCoverViewModel.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/16.
//

import Combine

public final class MusicPlayerAlbumCoverViewModel: ObservableObject {
    @Published public private(set) var albumCoverImageData: Data?

    private let albumCoverImageDataSubject = CurrentValueSubject<Data?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    public init() {
        albumCoverImageDataSubject
            .removeDuplicates()
            .assign(to: \.albumCoverImageData, on: self)
            .store(in: &cancellables)
    }

    // MARK: Input

    public func setAlbumCoverImageData(_ data: Data?) {
        albumCoverImageDataSubject.send(data)
    }
}
