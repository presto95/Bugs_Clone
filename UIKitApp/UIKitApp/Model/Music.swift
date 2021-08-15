//
//  Music.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/02.
//

import Foundation

struct Music: Decodable {
    let singer: String
    let album: String
    let title: String
    let duration: Int
    let image: String
    let file: String
    let lyrics: String
}

extension Music: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        --- Music ---
        Singer : \(singer)
        Album : \(album)
        title: \(title)
        duration: \(duration)
        lyrics: \(lyrics)
        -------------
        """
    }
}
