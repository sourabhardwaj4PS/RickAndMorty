//
//  RequestBuilder.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import Combine

public protocol ApiClient {
    associatedtype EndpointType: ApiEndpoint
    func execute<T: Decodable>(urlRequest request: URLRequest) throws -> AnyPublisher<T, Error>
}

public protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol { }

public class SessionApiClient<EndpointType: ApiEndpoint>: ApiClient {
    private var session: URLSessionProtocol
    public var request: URLRequest!

    // MARK: - Init

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: - Request
    public func createRequest(_ endpoint: EndpointType) throws -> URLRequest {
        guard var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true) else {
            throw RequestError.invalidComponents
        }
        
        // Add query params if provided
        if let queryItems = endpoint.queryItems {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
    
    public func execute<T: Decodable>(urlRequest request: URLRequest) throws -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ApiError.requestFailed
                }

                guard (200 ... 299).contains(httpResponse.statusCode) else {
                    throw ApiError.customError(statusCode: httpResponse.statusCode)
                }

                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error -> Error in
                return error
            })
            .eraseToAnyPublisher()
    }
}
