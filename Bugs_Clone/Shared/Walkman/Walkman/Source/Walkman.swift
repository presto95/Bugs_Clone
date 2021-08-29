//
//  Walkman.swift
//  Walkman
//
//  Created by Presto on 2021/08/15.
//

import AVFoundation
import Combine

public final class Walkman: NSObject {
    public var didFinishPlaying: AnyPublisher<Bool?, Never> { didFinishPlayingSubject.eraseToAnyPublisher() }
    public var decodeErrorDidOccur: AnyPublisher<Error?, Never> { decodeErrorDidOccurSubject.eraseToAnyPublisher() }
    public var currentTimeDidUpdate: AnyPublisher<TimeInterval?, Never> { currentTimeDidUpdateSubject.eraseToAnyPublisher()}

    private var didFinishPlayingSubject = CurrentValueSubject<Bool?, Never>(nil)
    private var decodeErrorDidOccurSubject = CurrentValueSubject<Error?, Never>(nil)
    private var currentTimeDidUpdateSubject = CurrentValueSubject<TimeInterval?, Never>(nil)

    private var player: AVAudioPlayer
    private var timer: Timer?

    public init(url: URL) throws {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            super.init()
            player.delegate = self
            player.prepareToPlay()
        } catch {
            throw WalkmanError.initFailed(derived: error)
        }
    }

    public init(data: Data) throws {
        do {
            player = try AVAudioPlayer(data: data)
            super.init()
            player.delegate = self
            player.prepareToPlay()
        } catch {
            throw WalkmanError.initFailed(derived: error)
        }
    }

    deinit {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Interface

extension Walkman {
    public var isPlaying: Bool {
        return player.isPlaying
    }

    public var currentTime: TimeInterval {
        get {
            return player.currentTime
        }
        set {
            player.currentTime = newValue
        }
    }

    public var endTime: TimeInterval {
        return player.duration
    }

    public func play() throws {
        guard isPlaying == false else { throw WalkmanError.playFailed }

        player.play()

        timer = makeTimer()
        timer?.fire()
    }

    public func pause() throws {
        guard isPlaying else { throw WalkmanError.pauseFailed }

        player.pause()

        timer?.invalidate()
        timer = nil
    }

    public func resume() throws {
        guard isPlaying else { throw WalkmanError.resumeFailed }

        player.play()

        timer = makeTimer()
        timer?.fire()
    }

    public func stop() throws {
        guard isPlaying else { throw WalkmanError.stopFailed }

        rewind()
    }
}

// MARK: - Built-in Timer

private extension Walkman {
    @objc func timerDidTick(_ timer: Timer) {
        currentTimeDidUpdateSubject.send(currentTime)
    }

    func makeTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: 0.1,
                                    target: self,
                                    selector: #selector(timerDidTick(_:)),
                                    userInfo: nil,
                                    repeats: true)
    }
}

// MARK: - Private Method

private extension Walkman {
    func rewind() {
        player.pause()
        player.currentTime = 0

        timer?.invalidate()
        timer = nil
    }
}

// MARK: - AVAudioPlayerDelegate

extension Walkman: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        rewind()

        didFinishPlayingSubject.send(flag)
    }

    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error = error else { return }
        decodeErrorDidOccurSubject.send(WalkmanError.decodeFailed(derived: error))
    }
}
