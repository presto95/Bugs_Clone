//
//  UIView+.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/03.
//

import UIKit

extension UIView {
    func addSubviews(@ViewArrayBuilder _ viewArrayBuilder: () -> [UIView]) {
        viewArrayBuilder().forEach { addSubview($0) }
    }
}
