//
//  MusicControlComponentProtocol.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/22.
//

import Combine

public protocol MusicControlComponentProtocol {
    var tap: AnyPublisher<Void?, Never> { get }
    func setNextMode(animated: Bool)
}
