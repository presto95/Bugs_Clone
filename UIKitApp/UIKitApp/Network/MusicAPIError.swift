//
//  MusicAPIError.swift
//  Bugs_Clone
//
//  Created by Presto on 2021/07/04.
//

import Foundation

class APIError: Error {
    var response: HTTPURLResponse

    init(response: HTTPURLResponse) {
        self.response = response
    }

    static func networkError(response: HTTPURLResponse) -> APIError {
        return APIError(response: response)
    }
}

class MusicAPIError: APIError {
    
}
