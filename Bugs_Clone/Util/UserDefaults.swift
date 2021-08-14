//
//  UserDefaults.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/08/14.
//

import Foundation

extension UserDefaults {
    var lastRepeatStatus: RepeatControl.Status? {
        get {
            guard let value = string(forKey: Key.lastRepeatStatus) else { return nil }
            return RepeatControl.Status(rawValue: value)
        }
        set {
            set(newValue?.rawValue, forKey: Key.lastRepeatStatus)
        }
    }

    var lastShuffleStatus: ShuffleControl.Status? {
        get {
            guard let value = string(forKey: Key.lastShuffleStatus) else { return nil }
            return ShuffleControl.Status(rawValue: value)
        }
        set {
            set(newValue?.rawValue, forKey: Key.lastShuffleStatus)
        }
    }
}

extension UserDefaults {
    enum Key {
        static let lastRepeatStatus = "lastRepeatStatus"
        static let lastShuffleStatus = "lastShuffleStatus"
    }
}
