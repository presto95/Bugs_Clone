//
//  Logger.swift
//  Common
//
//  Created by Presto on 2021/08/08.
//

import Foundation

public enum Logger {
    public static func log(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        print("LOG : \(message), file : \(file), function : \(function), line: \(line)")
    }
}
