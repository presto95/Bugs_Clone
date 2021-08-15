//
//  Alert.swift
//  UIKitApp
//
//  Created by Presto on 2021/08/08.
//

import UIKit

extension UIAlertController {
    static func alert(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }

    static func actionSheet(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }

    func action(title: String?,
                style: UIAlertAction.Style,
                enabled: Bool = true,
                handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = enabled
        addAction(action)
        return self
    }

    func textField(configurationHandler: ((UITextField) -> Void)? = nil) -> UIAlertController {
        addTextField(configurationHandler: configurationHandler)
        return self
    }

    func present(in viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: animated, completion: completion)
    }
}
