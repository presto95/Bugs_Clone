//
//  WalkmanError.swift
//  Walkman
//
//  Created by Presto on 2021/08/16.
//

public enum WalkmanError: Error {
    case initFailed(derived: Error)
    case decodeFailed(derived: Error)
    case playFailed
    case pauseFailed
    case resumeFailed
    case stopFailed
}
