//
//  NavigationInteractable.swift
//  UIKitMusicPlayer
//
//  Created by Presto on 2021/08/08.
//

import UIKit

protocol NavigationInteractable: UIViewController {
    func presentAlert(withMessage message: String?)
}
