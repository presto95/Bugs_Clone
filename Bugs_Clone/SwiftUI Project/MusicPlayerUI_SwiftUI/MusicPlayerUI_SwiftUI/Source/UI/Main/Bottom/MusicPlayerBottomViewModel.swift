//
//  MusicPlayerBottomViewModel.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import Combine
import Common

final class MusicPlayerBottomViewModel: ObservableObject {
    @Published var currentTime: TimeInterval = .zero
    @Published private(set) var currentTimeString: String?
    @Published var endTime: TimeInterval = .zero
    @Published private(set) var endTimeString: String?

    @Published private(set) var title: String?
    @Published private(set) var album: String?
    @Published private(set) var artist: String?

    private let titleSubject = CurrentValueSubject<String?, Never>(nil)
    private let albumSubject = CurrentValueSubject<String?, Never>(nil)
    private let artistSubject = CurrentValueSubject<String?, Never>(nil)
    private let currentTimeSubject = CurrentValueSubject<TimeInterval?, Never>(nil)
    private let endTimeSubject = CurrentValueSubject<TimeInterval?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()

    init() {
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
            .map { $0 ?? 0 }
            .map { Formatter.durationToString($0) }
            .assign(to: \.currentTimeString, on: self)
            .store(in: &cancellables)

        endTimeSubject
            .removeDuplicates()
            .map { $0 ?? 0 }
            .map { Formatter.durationToString($0) }
            .assign(to: \.endTimeString, on: self)
            .store(in: &cancellables)
    }

    func setData(title: String?, album: String?, artist: String?, endTime: TimeInterval) {
        titleSubject.send(title)
        albumSubject.send(album)
        artistSubject.send(artist)
        endTimeSubject.send(endTime)
    }

    func setCurrentTime(_ currentTime: TimeInterval) {
        currentTimeSubject.send(currentTime)
    }
}
