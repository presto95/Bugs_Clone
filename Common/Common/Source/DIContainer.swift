//
//  DIContainer.swift
//  Common
//
//  Created by Presto on 2021/07/28.
//

import Foundation

public final class DIContainer {
    public static let shared = DIContainer()

    private var storage: [String: Any] = [:]
    private init() {}

    public func register<Dependency>(_ object: Any, as type: Dependency.Type) {
        let key = String(reflecting: type)
        storage[key] = object
    }

    public func resolve<Dependency>(_ type: Dependency.Type) -> Dependency? {
        let key = String(reflecting: type)
        guard let dependency = storage[key] as? Dependency else { return nil }
        return dependency
    }
}
