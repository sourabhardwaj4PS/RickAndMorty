//
//  Extensions.swift
//
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation

extension Optional where Wrapped == String {
    public var value: String {
        switch self {
        case .some(let value): return value
        case .none: return ""
        }
    }
}

extension Optional where Wrapped == URL {
    public var value: URL {
        switch self {
        case .some(let value): return value
        case .none: return URL(string: "")!
        }
    }
}

extension URLRequest {
    public func log() {
        print("######### URLRequest Log #########")
        
        if let url = self.url {
            print("URL: \(url.absoluteString)")
        }
        
        if let method = self.httpMethod {
            print("Method: \(method)")
        }
        
        if let headers = self.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = self.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        
        print("##################################")
    }
}
