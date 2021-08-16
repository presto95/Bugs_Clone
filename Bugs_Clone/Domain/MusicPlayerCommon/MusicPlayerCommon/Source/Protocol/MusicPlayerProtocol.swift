//
//  MusicPlayerProtocol.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/16.
//

import Foundation
import Combine

public protocol MusicPlayerProtocol: AnyObject {
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get set }
    var endTime: TimeInterval { get }

    var currentTimeDidUpdatePublisher: Published<TimeInterval?>.Publisher { get }
    var didFinishPlayingPublisher: Published<Bool?>.Publisher { get }
    var decodeErrorDidOccurPublisher: Published<Error?>.Publisher { get }

    func play() throws
    func pause() throws
    func resume() throws
    func stop() throws
}
