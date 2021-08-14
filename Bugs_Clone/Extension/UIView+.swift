//
//  UIView+.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/03.
//

import UIKit

extension UIStackView {
    @discardableResult
    func arrangedSubviews(@SubviewBuilder _ builder: () -> [UIView]) -> UIStackView {
        builder().forEach { addArrangedSubview($0) }
        return self
    }
}

extension UIView {
    @discardableResult
    func subviews(@SubviewBuilder _ builder: () -> [UIView]) -> UIView {
        builder().forEach { addSubview($0) }
        return self
    }

}

@resultBuilder
enum SubviewBuilder {
    static func buildExpression(_ expression: UIView) -> [UIView] {
        return [expression]
    }

    static func buildBlock(_ components: [UIView]...) -> [UIView] {
        return components.flatMap { $0 }
    }

    static func buildOptional(_ component: [UIView]?) -> [UIView] {
        return component ?? []
    }

    static func buildEither(first component: [UIView]) -> [UIView] {
        return component
    }

    static func buildEither(second component: [UIView]) -> [UIView] {
        return component
    }
}
