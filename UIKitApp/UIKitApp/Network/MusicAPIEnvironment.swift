//
//  MusicAPIEnvironment.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import Foundation

enum MusicAPIVersion {
    case production
    case test
}

final class MusicAPIEnvironment {
    static let shared = MusicAPIEnvironment()

    private init() {}

    var version: MusicAPIVersion = .production

    func musicURL() -> URL? {
        switch version {
        case .production:
            return URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")
        case .test:
            return URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")
        }
    }
}
