//
//  MusicPlayerBottomViewModel.swift
//  UIKitMusicPlayer
//
//  Created by Presto on 2021/07/24.
//

import Combine
import Common

final class MusicPlayerBottomViewModel: ObservableObject {
    @Published private(set) var title: String?
    @Published private(set) var albumName: String?
    @Published private(set) var artist: String?
    @Published private(set) var currentTime: String?
    @Published private(set) var endTime: String?

    private let titleSubject = CurrentValueSubject<String?, Never>(nil)
    private let albumNameSubject = CurrentValueSubject<String?, Never>(nil)
    private let artistSubject = CurrentValueSubject<String?, Never>(nil)
    private let currentTimeSubject = CurrentValueSubject<TimeInterval?, Never>(nil)
    private let endTimeSubject = CurrentValueSubject<TimeInterval?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    init() {
        titleSubject
            .removeDuplicates()
            .assign(to: \.title, on: self)
            .store(in: &cancellables)

        albumNameSubject
            .removeDuplicates()
            .assign(to: \.albumName, on: self)
            .store(in: &cancellables)

        artistSubject
            .removeDuplicates()
            .assign(to: \.artist, on: self)
            .store(in: &cancellables)

        currentTimeSubject
            .removeDuplicates()
            .map { $0 ?? 0 }
            .map { Formatter.durationToString($0) }
            .assign(to: \.currentTime, on: self)
            .store(in: &cancellables)

        endTimeSubject
            .removeDuplicates()
            .map { $0 ?? 0 }
            .map { Formatter.durationToString($0) }
            .assign(to: \.endTime, on: self)
            .store(in: &cancellables)
    }

    // MARK: Input

    func setData(title: String?, albumName: String?, artist: String?, endTime: TimeInterval) {
        titleSubject.send(title)
        albumNameSubject.send(albumName)
        artistSubject.send(artist)
        endTimeSubject.send(endTime)
    }

    func setCurrentTime(_ currentTime: TimeInterval) {
        currentTimeSubject.send(currentTime)
    }
}
