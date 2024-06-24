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
    case decodingError(DecodingError)
    case unknownError(Error)
    
    public static func ==(lhs: ApiError, rhs: ApiError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl),
             (.invalidParameter, .invalidParameter),
             (.invalidRequest, .invalidRequest),
             (.requestFailed, .requestFailed),
             (.decodingFailed, .decodingFailed):
            return true
        case (.customError(let lhsStatus), .customError(let rhsStatus)):
            return lhsStatus == rhsStatus
        case (.customError(let lhsMessage), .customError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.unknownError(let lhsError), .unknownError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

public enum RequestError: Error {
    case invalidURL
    case invalidComponents
}

