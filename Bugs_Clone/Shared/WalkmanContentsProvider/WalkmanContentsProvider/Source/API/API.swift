//
//  API.swift
//  WalkmanContentsProvider
//
//  Created by Presto on 2021/07/04.
//

import Foundation
import Combine

public enum API {
    public static func musicPublisher() -> AnyPublisher<Music, Error> {
        Just(APIEnvironment.shared.musicURL())
            .compactMap { $0 }
            .setFailureType(to: URLError.self)
            .flatMap(URLSession.shared.dataTaskPublisher(for:))
            .map(\.data)
            .mapError { $0 as Error }
            .decode(type: Music.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
