//
//  Formatter.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/25.
//

import Foundation

enum Formatter {
    static func durationToString(_ duration: TimeInterval) -> String {
        return durationToString(Int(duration))
    }

    static func durationToString(_ duration: Int) -> String {
        let minute = duration / 60
        let second = duration % 60
        return "\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
    }
}
