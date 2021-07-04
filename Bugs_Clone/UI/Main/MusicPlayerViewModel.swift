//
//  MusicPlayerViewModel.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/03.
//

import Foundation
import Combine

final class MusicPlayerViewModel: ObservableObject {
    @Published private(set) var albumCoverImageData: Data?
    @Published private(set) var musicData: Data?

    private(set) var audioPlayer: AudioPlayerProtocol?

    var topViewModel: MusicPlayerTopViewModel?
    var bottomViewModel: MusicPlayerBottomViewModel?

    private let albumCoverImageDataSubject = CurrentValueSubject<Data?, Never>(nil)
    private let musicDataSubject = CurrentValueSubject<Data?, Never>(nil)
    private let musicRequestResultSubject = CurrentValueSubject<Result<Music, Error>?, Never>(nil)
    
    private var audioInteractor: AudioInteractable? {
        return DIContainer.shared.resolve(AudioInteractable.self)
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        albumCoverImageDataSubject
            .assign(to: \.albumCoverImageData, on: self)
            .store(in: &cancellables)

        musicDataSubject
            .assign(to: \.musicData, on: self)
            .store(in: &cancellables)

        musicDataSubject
            .compactMap { $0 }
            .tryMap { try AudioPlayer(data: $0) }
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    Logger.log(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] audioPlayer in
//                DIContainer.shared.register(audioPlayer, as: AudioPlayerProtocol.self)
                self?.audioPlayer = audioPlayer

                self?.audioInteractor?.updateEndTime(audioPlayer.endTime)
                self?.bindAudioPlayer(audioPlayer)
//                NotificationCenter.default.post(Notification(name: .audioPlayerDidInitialize,
//                                                             object: self,
//                                                             userInfo: ["audioPlayer": audioPlayer]))
            })
            .store(in: &cancellables)

        let sharedMusicRequestResult = musicRequestResultSubject
            .tryCompactMap { try $0?.get() }
            .receive(on: DispatchQueue.main)
            .share()

        sharedMusicRequestResult
            .map(\.image)
            .receive(on: DispatchQueue.global(qos: .utility))
            .compactMap { URL(string: $0) }
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
                self?.topViewModel?.setAlbumCoverImageData(imageData)
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
                self?.topViewModel?.setLyricsRawString(data.lyrics)
                self?.bottomViewModel?.setData(title: data.title,
                                               albumName: data.album,
                                               artist: data.singer,
                                               endTime: TimeInterval(data.duration))
            })
            .store(in: &cancellables)
    }

    // MARK: Input

    func requestMusic() {
        MusicAPI.musicPublisher()
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
    func bindAudioPlayer(_ audioPlayer: AudioPlayerProtocol) {
        audioPlayer.currentTimeDidUpdatePublisher
            .compactMap { $0 }
            .sink { [weak self] currentTime in
                self?.audioInteractor?.updateCurrentTime(currentTime)
            }
            .store(in: &cancellables)

        audioPlayer.didFinishPlayingPublisher
            .compactMap { $0 }
            .filter { $0 }
            .sink { [weak self] _ in
                NotificationCenter.default.post(Notification(name: .audioPlayerDidEnd))
            }
            .store(in: &cancellables)

        audioPlayer.decodeErrorDidOccurPublisher
            .compactMap { $0 }
            .sink { [weak self] error in
                DIContainer.shared.resolve(NavigationInteractable.self)?
                    .presentAlert(withMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
    }
}
