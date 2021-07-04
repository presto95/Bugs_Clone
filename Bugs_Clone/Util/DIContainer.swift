//
//  DIContainer.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/28.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    private var storage: [String: Any] = [:]
    private init() {}

    func register<Dependency>(_ object: Any, as type: Dependency.Type) {
        let key = String(reflecting: type)
        storage[key] = object
    }

    func resolve<Dependency>(_ type: Dependency.Type) -> Dependency? {
        let key = String(reflecting: type)
        guard let dependency = storage[key] as? Dependency else { return nil }
        return dependency
    }
}
