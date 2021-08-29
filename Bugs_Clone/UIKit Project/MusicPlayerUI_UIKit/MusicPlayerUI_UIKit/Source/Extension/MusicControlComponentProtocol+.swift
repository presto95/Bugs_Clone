//
//  MusicControlComponentProtocol+.swift
//  MusicPlayerUI_UIKit
//
//  Created by Presto on 2021/08/22.
//

import UIKit
import MusicPlayerCommon

extension MusicControlComponentProtocol {
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
