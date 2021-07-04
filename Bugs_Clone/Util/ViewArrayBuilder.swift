//
//  ViewArrayBuilder.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/24.
//

import UIKit

@resultBuilder
enum ViewArrayBuilder {
    static func buildExpression(_ expression: UIView) -> [UIView] {
        return [expression]
    }

    static func buildBlock(_ components: [UIView]...) -> [UIView] {
        return components.flatMap { $0 }
    }

    static func buildEither(first component: [UIView]) -> [UIView] {
        return component
    }

    static func buildEither(second component: [UIView]) -> [UIView] {
        return component
    }

    static func buildArray(_ components: [[UIView]]) -> [UIView] {
        return components.flatMap { $0 }
    }

    static func buildOptional(_ component: [UIView]?) -> [UIView] {
        return component ?? []
    }

    static func buildFinalResult(_ component: [UIView]) -> [UIView] {
        return component
    }
}
