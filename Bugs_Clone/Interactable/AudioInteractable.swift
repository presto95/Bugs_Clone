//
//  AudioUIInteractable.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/08/08.
//

import Foundation

protocol AudioInteractable: AnyObject {
    var audioPlayer: AudioPlayerProtocol? { get }
    var seekbar: SeekbarProtocol? { get }
    var lyricsView: LyricsViewProtocol? { get }

    func updateCurrentTime(_ currentTime: TimeInterval)
    func updateEndTime(_ endTime: TimeInterval)
    func updateAudioCurrentTime(_ currentTime: TimeInterval)

    func playAudio() -> Bool
    func pauseAudio() -> Bool
}
