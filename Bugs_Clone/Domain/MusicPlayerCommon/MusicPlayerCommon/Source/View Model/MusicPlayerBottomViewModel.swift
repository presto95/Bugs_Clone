//
//  MusicPlayerBottomViewModel.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/07/24.
//

import Combine
import Common

public final class MusicPlayerBottomViewModel: ObservableObject {
    @Published public private(set) var title: String?
    @Published public private(set) var album: String?
    @Published public private(set) var artist: String?
    @Published public var currentTimeInSeconds: TimeInterval?
    @Published public private(set) var currentTime: String?
    @Published public var endTimeInSeconds: TimeInterval?
    @Published public private(set) var endTime: String?

    private let titleSubject = CurrentValueSubject<String?, Never>(nil)
    private let albumSubject = CurrentValueSubject<String?, Never>(nil)
    private let artistSubject = CurrentValueSubject<String?, Never>(nil)
    private let currentTimeSubject = CurrentValueSubject<TimeInterval?, Never>(nil)
    private let endTimeSubject = CurrentValueSubject<TimeInterval?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    public init() {
        titleSubject
            .removeDuplicates()
            .assign(to: \.title, on: self)
            .store(in: &cancellables)

        albumSubject
            .removeDuplicates()
            .assign(to: \.album, on: self)
            .store(in: &cancellables)

        artistSubject
            .removeDuplicates()
            .assign(to: \.artist, on: self)
            .store(in: &cancellables)

        currentTimeSubject
            .removeDuplicates()
            .assign(to: \.currentTimeInSeconds, on: self)
            .store(in: &cancellables)

        currentTimeSubject
            .removeDuplicates()
            .map { $0 ?? 0 }
            .map { Formatter.durationToString($0) }
            .assign(to: \.currentTime, on: self)
            .store(in: &cancellables)

        endTimeSubject
            .removeDuplicates()
            .assign(to: \.endTimeInSeconds, on: self)
            .store(in: &cancellables)

        endTimeSubject
            .removeDuplicates()
            .map { $0 ?? 0 }
            .map { Formatter.durationToString($0) }
            .assign(to: \.endTime, on: self)
            .store(in: &cancellables)
    }

    // MARK: Input

    public func setSongInfo(title: String?, album: String?, artist: String?, endTime: TimeInterval) {
        titleSubject.send(title)
        albumSubject.send(album)
        artistSubject.send(artist)
        endTimeSubject.send(endTime)
    }

    public func setCurrentTime(_ currentTime: TimeInterval) {
        currentTimeSubject.send(currentTime)
    }
}
