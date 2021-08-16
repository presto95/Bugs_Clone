//
//  Walkman+MusicPlayerProtocol.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/08/15.
//

import Foundation
import Combine
import Walkman

extension Walkman: MusicPlayerProtocol {
    var currentTimeDidUpdatePublisher: Published<TimeInterval?>.Publisher { $currentTimeDidUpdate }
    var didFinishPlayingPublisher: Published<Bool?>.Publisher { $didFinishPlaying }
    var decodeErrorDidOccurPublisher: Published<Error?>.Publisher { $decodeErrorDidOccur }
}
