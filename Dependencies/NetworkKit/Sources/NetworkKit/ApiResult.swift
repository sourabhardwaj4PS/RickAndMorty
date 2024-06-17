//
//  ApiResult.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation

public struct ApiResult<T: Codable>: Codable {
    public let status: String
    public let data: T?
    
    public init(status: String, data: T?) {
        self.status = status
        self.data = data
    }
}

extension ApiResult {
    public var success: Bool {
        status == "success"
    }
}
