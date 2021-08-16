//
//  MusicPlayerViewModel.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/07/03.
//

import Combine
import MusicPlayerCommon
import Walkman
import WalkmanContentsProvider
import Common

public final class MusicPlayerViewModel: ObservableObject {
    @Published private(set) var albumCoverImageData: Data?
    @Published private(set) var musicData: Data?

    private(set) var musicPlayer: MusicPlayerProtocol?

    var topViewModel: MusicPlayerTopViewModel?
    var bottomViewModel: MusicPlayerBottomViewModel?

    private let albumCoverImageDataSubject = CurrentValueSubject<Data?, Never>(nil)
    private let musicDataSubject = CurrentValueSubject<Data?, Never>(nil)
    private let musicRequestResultSubject = CurrentValueSubject<Result<Music, Error>?, Never>(nil)
    
    private var musicInteractor: MusicInteractable? {
        return DIContainer.shared.resolve(MusicInteractable.self)
    }

    private var navigationInteractor: NavigationInteractable? {
        return DIContainer.shared.resolve(NavigationInteractable.self)
    }

    private var cancellables = Set<AnyCancellable>()

    public init() {
        albumCoverImageDataSubject
            .assign(to: \.albumCoverImageData, on: self)
            .store(in: &cancellables)

        musicDataSubject
            .assign(to: \.musicData, on: self)
            .store(in: &cancellables)

        musicDataSubject
            .compactMap { $0 }
            .tryMap { try Walkman(data: $0) }
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    Logger.log(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] musicPlayer in
                self?.musicPlayer = musicPlayer

                self?.musicInteractor?.updateEndTime(musicPlayer.endTime)
                self?.bindMusicPlayer(musicPlayer)
            })
            .store(in: &cancellables)

        let sharedMusicRequestResult = musicRequestResultSubject
            .tryCompactMap { try $0?.get() }
            .receive(on: DispatchQueue.main)
            .share()

        sharedMusicRequestResult
            .map(\.image)
            .receive(on: DispatchQueue.global(qos: .utility))
            .compactMap(URL.init)
            .tryMap { try Data(contentsOf: $0) }
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    Logger.log(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] imageData in
                self?.albumCoverImageDataSubject.send(imageData)
                self?.topViewModel?.albumCoverViewModel?.setAlbumCoverImageData(imageData)
            })
            .store(in: &cancellables)

        sharedMusicRequestResult
            .map(\.file)
            .receive(on: DispatchQueue.global(qos: .utility))
            .compactMap { URL(string: $0) }
            .tryMap { try Data(contentsOf: $0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    Logger.log(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] musicData in
                self?.musicDataSubject.send(musicData)
            })
            .store(in: &cancellables)

        sharedMusicRequestResult
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    Logger.log(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                self?.topViewModel?.lyricsViewModel?.setLyricRawString(data.lyrics)
                self?.bottomViewModel?.setSongInfo(title: data.title,
                                                   album: data.album,
                                                   artist: data.singer,
                                                   endTime: TimeInterval(data.duration))
            })
            .store(in: &cancellables)
    }

    // MARK: Input

    func requestMusic() {
        API.musicPublisher()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.musicRequestResultSubject.send(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] music in
                self?.musicRequestResultSubject.send(.success(music))
            })
            .store(in: &cancellables)
    }
}

private extension MusicPlayerViewModel {
    func bindMusicPlayer(_ musicPlayer: MusicPlayerProtocol) {
        musicPlayer.currentTimeDidUpdatePublisher
            .compactMap { $0 }
            .sink { [weak self] currentTime in
                self?.musicInteractor?.updateCurrentTime(currentTime)
            }
            .store(in: &cancellables)

        musicPlayer.didFinishPlayingPublisher
            .compactMap { $0 }
            .filter { $0 }
            .sink { [weak self] _ in
                self?.musicInteractor?.reset()
            }
            .store(in: &cancellables)

        musicPlayer.decodeErrorDidOccurPublisher
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.navigationInteractor?.presentAlert(withMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
    }
}
