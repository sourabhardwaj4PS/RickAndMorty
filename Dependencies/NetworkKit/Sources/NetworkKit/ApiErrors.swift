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
}

//extension ApiError {
//    var localizedDescription: String {
//        switch self {
//        case .invalidUrl:
//            return "Invalid url"
//        case .invalidParameter:
//            return "Invalid parameter"
//        case .invalidRequest:
//            return "Invalid request"
//        case .requestFailed:
//            return "Request failed"
//        case .decodingFailed:
//            return "Decoding failed"
//        case .customError(statusCode: let statusCode):
//            return "New error with status code: \(statusCode)"
//        }
//    }
//}
