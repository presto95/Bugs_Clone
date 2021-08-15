//
//  WalkmanProtocol.swift
//  UIKitApp
//
//  Created by Presto on 2021/08/15.
//

import Foundation

protocol MusicPlayerProtocol: AnyObject {
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get set }
    var endTime: TimeInterval { get }

    var currentTimeDidUpdatePublisher: Published<TimeInterval?>.Publisher { get }
    var didFinishPlayingPublisher: Published<Bool?>.Publisher { get }
    var decodeErrorDidOccurPublisher: Published<Error?>.Publisher { get }

    @discardableResult
    func play() -> Bool

    @discardableResult
    func pause() -> Bool

    @discardableResult
    func resume() -> Bool

    @discardableResult
    func stop() -> Bool
}
