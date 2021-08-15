//
//  Music.swift
//  WalkmanContentsProvider
//
//  Created by Presto on 2021/07/02.
//

import Foundation

public struct Music: Decodable {
    public let singer: String
    public let album: String
    public let title: String
    public let duration: Int
    public let image: String
    public let file: String
    public let lyrics: String
}

extension Music: CustomDebugStringConvertible {
    public var debugDescription: String {
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
