//
//  LyricsController.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/22.
//

public protocol LyricsController {
    func selectLyricItem(before time: TimeInterval)
    func unselectLyricItem()
}
