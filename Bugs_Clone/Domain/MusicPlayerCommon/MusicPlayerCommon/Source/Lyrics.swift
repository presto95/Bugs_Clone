//
//  Lyrics.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/08.
//

import Foundation

public struct Lyrics: Equatable {
    public struct Item: Equatable {
        public var time: TimeInterval
        public var lyric: String
    }

    private var storage: [Item] = []

    public init?(rawData: String?) {
        guard let rawData = rawData else { return nil }

        let components = rawData.components(separatedBy: "\n")

        for component in components {
            let array = Array(component)
            let startParenthesisIndex = array.firstIndex(of: "[") ?? 0
            let endParenthesisIndex = array.firstIndex(of: "]") ?? 0
            let timeString = String(array[startParenthesisIndex + 1 ..< endParenthesisIndex])
            let lyricString = String(array[endParenthesisIndex + 1 ..< array.endIndex])

            let timeStringComponents = timeString.components(separatedBy: ":")
            let minuteString = timeStringComponents[0]
            let secondString = timeStringComponents[1]
            let millisecondString = timeStringComponents[2]
            let minuteToSecond = (Double(minuteString) ?? 0) * 60
            let millisecondToSecond = (Double(millisecondString) ?? 0) / 1000
            let seconds = minuteToSecond + (Double(secondString) ?? 0) + millisecondToSecond

            storage.append(Item(time: seconds, lyric: lyricString))
        }

        if storage.isEmpty { return nil }
    }

    public var count: Int {
        return storage.count
    }

    public func index(before time: TimeInterval) -> Int? {
        return storage.lastIndex(where: { $0.time <= time })
    }

    public func index(after time: TimeInterval) -> Int? {
        return storage.firstIndex(where: { $0.time >= time })
    }

    public func lyricItem(before time: TimeInterval) -> Item? {
        guard let index = index(before: time) else { return nil }
        return storage[index]
    }

    public func lyric(before time: TimeInterval) -> String? {
        guard let index = index(before: time) else { return nil }
        return storage[index].lyric
    }

    public func lyricTime(before time: TimeInterval) -> TimeInterval? {
        guard let index = index(before: time) else { return nil }
        return storage[index].time
    }

    public func lyricItem(after time: TimeInterval) -> Item? {
        guard let index = index(after: time) else { return nil }
        return storage[index]
    }

    public func lyric(after time: TimeInterval) -> String? {
        guard let index = index(after: time) else { return nil }
        return storage[index].lyric
    }

    public func lyricTime(after time: TimeInterval) -> TimeInterval? {
        guard let index = index(after: time) else { return nil }
        return storage[index].time
    }

    public func lyricItem(at index: Int) -> Item? {
        return storage[index]
    }

    public func lyric(at index: Int) -> String? {
        return storage[index].lyric
    }

    public func lyricTime(at index: Int) -> TimeInterval? {
        return storage[index].time
    }
}
