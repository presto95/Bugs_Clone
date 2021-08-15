//
//  MusicAPI.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import Foundation
import Combine

enum MusicAPI {
    static func musicPublisher() -> AnyPublisher<Music, Error> {
        Just(MusicAPIEnvironment.shared.musicURL())
            .compactMap { $0 }
            .setFailureType(to: URLError.self)
            .flatMap(URLSession.shared.dataTaskPublisher(for:))
            .map(\.data)
            .mapError { $0 as Error }
            .decode(type: Music.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
