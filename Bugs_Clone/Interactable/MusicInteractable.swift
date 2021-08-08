//
//  MusicInteractable.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/08/08.
//

import Foundation

protocol MusicInteractable: AnyObject {
    var musicPlayer: MusicPlayerProtocol? { get }
    var seekbar: SeekbarProtocol? { get }
    var lyricsView: LyricsViewProtocol? { get }

    func updateCurrentTime(_ currentTime: TimeInterval)
    func updateEndTime(_ endTime: TimeInterval)
    func updateMusicCurrentTime(_ currentTime: TimeInterval)

    func playMusic() -> Bool
    func pauseMusic() -> Bool
}
