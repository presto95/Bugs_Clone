//
//  SeekingController.swift
//  MusicPlayerCommon
//
//  Created by Presto on 2021/08/22.
//

public protocol SeekingController {
    var currentTime: TimeInterval { get }
    func setCurrentTime(_ currentTime: TimeInterval)
    var endTime: TimeInterval { get }
    func setEndTime(_ endTime: TimeInterval)
}
