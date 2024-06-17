//
//  MockEndpoint.swift
//  
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import XCTest
 
@testable import NetworkKit

public enum MockEndpoint: ApiEndpoint {
    
    case characters(page: Int)
    
    var baseURL: URL { URL(string: "https://mocked.com/api")! }
    
    var path: String {
        switch self {
        case .characters:
            return "/character/"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .characters(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
    
    var method: NetworkKit.HttpMethod { .get }
    
    var headers: [String : String]? {
        return [
            "Authorization": "Bearer-Mocked ABCDEFG123456",
            "Content-Type": "application/json"
        ]
    }
    
    var body: Data? { nil }
}
