//
//  AudioPlayer.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import AVFoundation

protocol AudioPlayerProtocol: AnyObject {
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get set }
    var endTime: TimeInterval { get }
    func play() -> Bool
    func pause() -> Bool
    func resume() -> Bool
    func stop() -> Bool

    var currentTimeDidUpdatePublisher: Published<TimeInterval?>.Publisher { get }
    var didFinishPlayingPublisher: Published<Bool?>.Publisher { get }
    var decodeErrorDidOccurPublisher: Published<Error?>.Publisher { get }
}

final class AudioPlayer: NSObject {
    @Published private(set) var didFinishPlaying: Bool?
    @Published private(set) var decodeErrorDidOccur: Error?
    @Published private(set) var currentTimeDidUpdate: TimeInterval?

    weak var seekbar: Seekbar?
    private var player: AVAudioPlayer
    private var timer: Timer?

    init(url: URL) throws {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            super.init()
            player.delegate = self
            player.prepareToPlay()
        } catch {
            throw error
        }
    }

    init(data: Data) throws {
        do {
            player = try AVAudioPlayer(data: data)
            super.init()
            player.delegate = self
            player.prepareToPlay()
        } catch {
            throw error
        }
    }

    deinit {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Interface

extension AudioPlayer: AudioPlayerProtocol {
    var currentTimeDidUpdatePublisher: Published<TimeInterval?>.Publisher {
        return $currentTimeDidUpdate
    }

    var didFinishPlayingPublisher: Published<Bool?>.Publisher {
        return $didFinishPlaying
    }

    var decodeErrorDidOccurPublisher: Published<Error?>.Publisher {
        return $decodeErrorDidOccur
    }

    var isPlaying: Bool {
        return player.isPlaying
    }

    var currentTime: TimeInterval {
        get {
            return player.currentTime
        }
        set {
            player.currentTime = newValue
        }
    }

    var endTime: TimeInterval {
        return player.duration
    }

    @discardableResult
    func play() -> Bool {
        guard isPlaying == false else { return false }
        player.play()

        timer = makeTimer()
        timer?.fire()

        return true
    }

    @discardableResult
    func pause() -> Bool {
        guard isPlaying else { return false }
        player.pause()

        timer?.invalidate()
        timer = nil

        return true
    }

    @discardableResult
    func resume() -> Bool {
        guard isPlaying else { return false }
        player.play()

        timer = makeTimer()
        timer?.fire()

        return true
    }

    @discardableResult
    func stop() -> Bool {
        guard isPlaying else { return false }
        player.pause()
        player.currentTime = 0
        
        timer?.invalidate()
        timer = nil

        return true
    }
}

// MARK: - Built-in Timer

private extension AudioPlayer {
    @objc func timerDidTick(_ timer: Timer) {
        currentTimeDidUpdate = currentTime
    }

    func makeTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: 0.1,
                                    target: self,
                                    selector: #selector(timerDidTick(_:)),
                                    userInfo: nil,
                                    repeats: true)
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlaying = flag
        player.stop()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error = error else { return }
        decodeErrorDidOccur = error
    }
}
