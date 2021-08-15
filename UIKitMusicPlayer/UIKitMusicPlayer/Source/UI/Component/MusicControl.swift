//
//  MusicControl.swift
//  UIKitMusicPlayer
//
//  Created by Presto on 2021/07/04.
//

import UIKit

protocol MusicControl {
    func setNextStatus(animated: Bool)
}

extension MusicControl {
    func runScaleAnimation(to view: UIView) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.autoreverse, .curveEaseInOut],
                       animations: {
                        view.transform = view.transform.scaledBy(x: 0.8, y: 0.8)
                       },
                       completion: { _ in
                        view.transform = .identity
                       })
    }
}
