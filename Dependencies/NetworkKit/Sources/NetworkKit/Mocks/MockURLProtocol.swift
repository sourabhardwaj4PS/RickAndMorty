//
//  MockURLProtocol.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Combine
import Foundation

@testable import NetworkKit

public class MockURLProtocol: URLProtocol {
    
    // MARK: - Mocking Data
    public static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    public static var requestFailed = false
    public static var decodingFailed = false
        
    public static func resetMockData() {
        requestHandler = nil
        requestFailed = false
        decodingFailed = false
    }
    
    /// Avoid fatalError("Handler is unavailable.")
    public static func populateRequestHandler() {
        requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 0, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
    }

    // MARK: - Class Methods

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        do {
            guard let handler = MockURLProtocol.requestHandler else {
                fatalError("Handler is unavailable.")
            }

            if MockURLProtocol.decodingFailed {
                throw NSError(domain: "com.example.errorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Simulated generic error"])
            }
            
            let (response, data) = try handler(request)
            
            if MockURLProtocol.requestFailed {
                client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: .notAllowed)
            } 
            else {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    public override func stopLoading() {
        //
    }
}

