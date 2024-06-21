//
//  ApiErrors.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation

//
// Error Handling
//
public enum ApiError: Error, Equatable {
    case invalidUrl
    case invalidParameter
    case invalidRequest
    case requestFailed
    case decodingFailed
    case customError(statusCode: Int)
    case customError(message: String)
}

public enum RequestError: Error {
    case invalidURL
    case invalidComponents
}

