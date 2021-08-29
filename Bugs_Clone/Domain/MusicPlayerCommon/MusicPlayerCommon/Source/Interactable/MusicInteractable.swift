//
//  MusicInteractable.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/08/08.
//

public protocol MusicInteractable {
    var musicPlayerController: MusicPlayerController? { get }
    var seekingController: SeekingController? { get }
    var lyricsController: LyricsController? { get }
    var musicControlController: MusicControlController? { get }

    func updateCurrentTime(_ currentTime: TimeInterval)
    func updateEndTime(_ endTime: TimeInterval)
    func updateMusicCurrentTime(_ currentTime: TimeInterval)

    func reset()

    func playMusic() throws
    func pauseMusic() throws
}
