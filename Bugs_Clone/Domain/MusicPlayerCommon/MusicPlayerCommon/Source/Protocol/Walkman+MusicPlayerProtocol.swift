//
//  Walkman+MusicPlayerController.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/16.
//

import Combine
import Walkman

extension Walkman: MusicPlayerController {
    public func setCurrentTime(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
    }
}
