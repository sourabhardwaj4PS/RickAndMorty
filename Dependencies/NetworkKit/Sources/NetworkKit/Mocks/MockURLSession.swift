//
//  MockURLSession.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Combine
import Foundation

public class MockURLSession: URLSessionProtocol {
    
    var delegate: URLSessionDelegate? = DefaultSessionDelegate()
    
    public init(delegate: URLSessionDelegate? = nil) {
        self.delegate = delegate
    }
    
    public func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config, delegate: self.delegate, delegateQueue: nil)
        return URLSession.DataTaskPublisher(request: request, session: session)
    }
}


