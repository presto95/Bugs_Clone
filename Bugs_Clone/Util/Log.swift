//
//  Log.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/08/08.
//

import Foundation

enum Logger {
    static func log(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        print("LOG : \(message), file : \(file), function : \(function), line: \(line)")
    }
}
