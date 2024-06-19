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
    
    public var baseURL: URL { URL(string: "https://mocked.com/api")! }
    
    public var path: String {
        switch self {
        case .characters:
            return "/character/"
        }
    }
    
    public var queryItems: [URLQueryItem]? {
        switch self {
        case .characters(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
    
    public var method: NetworkKit.HttpMethod { .get }
    
    public var headers: [String : String]? {
        return [
            "Authorization": "Bearer-Mocked ABCDEFG123456",
            "Content-Type": "application/json"
        ]
    }
    
    public var body: Data? { nil }
}
