//
//  MusicPlayerRootUIInteractable.swift
//  UIKitMusicPlayer
//
//  Created by Presto on 2021/08/08.
//

import UIKit
import MusicPlayerCommon

protocol MusicPlayerRootUIInteractable: AnyObject {
    func adjustRootViews(by displayingInfo: DisplayingInfo)
}
