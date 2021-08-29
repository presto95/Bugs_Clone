//
//  MusicPlayerController.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/16.
//

import Foundation
import Combine

public protocol MusicPlayerController {
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    func setCurrentTime(_ currentTime: TimeInterval)
    var endTime: TimeInterval { get }

    var currentTimeDidUpdate: AnyPublisher<TimeInterval?, Never> { get }
    var didFinishPlaying: AnyPublisher<Bool?, Never> { get }
    var decodeErrorDidOccur: AnyPublisher<Error?, Never> { get }

    func play() throws
    func pause() throws
    func resume() throws
    func stop() throws
}
