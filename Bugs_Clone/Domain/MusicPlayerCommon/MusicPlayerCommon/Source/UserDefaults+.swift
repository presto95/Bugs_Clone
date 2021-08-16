//
//  UserDefaults.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/14.
//

public extension UserDefaults {
    var lastRepeatMode: RepeatMode? {
        get {
            guard let value = string(forKey: Key.lastRepeatMode) else { return nil }
            return RepeatMode(rawValue: value)
        }
        set {
            set(newValue?.rawValue, forKey: Key.lastRepeatMode)
        }
    }

    var lastShuffleMode: ShuffleMode? {
        get {
            guard let value = string(forKey: Key.lastShuffleMode) else { return nil }
            return ShuffleMode(rawValue: value)
        }
        set {
            set(newValue?.rawValue, forKey: Key.lastShuffleMode)
        }
    }
}

public extension UserDefaults {
    enum Key {
        static let lastRepeatMode = "lastRepeatMode"
        static let lastShuffleMode = "lastShuffleMode"
    }
}
