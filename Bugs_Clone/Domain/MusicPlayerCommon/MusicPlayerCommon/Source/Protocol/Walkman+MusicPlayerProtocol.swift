//
//  Walkman+MusicPlayerProtocol.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/16.
//

import Combine
import Walkman

extension Walkman: MusicPlayerProtocol {
    public var currentTimeDidUpdatePublisher: Published<TimeInterval?>.Publisher { $currentTimeDidUpdate }
    public var didFinishPlayingPublisher: Published<Bool?>.Publisher { $didFinishPlaying }
    public var decodeErrorDidOccurPublisher: Published<Error?>.Publisher { $decodeErrorDidOccur }
}

