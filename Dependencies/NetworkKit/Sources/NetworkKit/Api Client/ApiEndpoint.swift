//
//  ApiEndpoint.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation

//
// All required attributes for request building
//
public protocol ApiEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

