//
//  APIEnvironment.swift
//  WalkmanContentsProvider
//
//  Created by Presto on 2021/07/04.
//

import Foundation

public final class APIEnvironment {
    public static let shared = APIEnvironment()

    private init() {}

    public var version: APIVersion = .production

    public func musicURL() -> URL? {
        switch version {
        case .production:
            return URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")
        case .test:
            return URL(string: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/song.json")
        }
    }
}
