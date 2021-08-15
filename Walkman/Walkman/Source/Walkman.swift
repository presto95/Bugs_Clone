//
//  Walkman.swift
//  Walkman
//
//  Created by Presto on 2021/08/15.
//

import AVFoundation
import Combine

public final class Walkman: NSObject {
    @Published public private(set) var didFinishPlaying: Bool?
    @Published public private(set) var decodeErrorDidOccur: Error?
    @Published public private(set) var currentTimeDidUpdate: TimeInterval?

    private var player: AVAudioPlayer
    private var timer: Timer?

    public init(url: URL) throws {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            super.init()
            player.delegate = self
            player.prepareToPlay()
        } catch {
            throw error
        }
    }

    public init(data: Data) throws {
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

    @discardableResult
    public func play() -> Bool {
        guard isPlaying == false else { return false }
        player.play()

        timer = makeTimer()
        timer?.fire()

        return true
    }

    @discardableResult
    public func pause() -> Bool {
        guard isPlaying else { return false }
        player.pause()

        timer?.invalidate()
        timer = nil

        return true
    }

    @discardableResult
    public func resume() -> Bool {
        guard isPlaying else { return false }
        player.play()

        timer = makeTimer()
        timer?.fire()

        return true
    }

    @discardableResult
    public func stop() -> Bool {
        guard isPlaying else { return false }
        player.pause()
        player.currentTime = 0

        timer?.invalidate()
        timer = nil

        return true
    }
}

// MARK: - Built-in Timer

private extension Walkman {
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

extension Walkman: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.pause()
        player.currentTime = 0

        timer?.invalidate()
        timer = nil

        didFinishPlaying = flag
    }

    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error = error else { return }
        decodeErrorDidOccur = error
    }
}
