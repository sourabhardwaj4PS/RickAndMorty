//
//  CharacterRemoteDataSource.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import Combine
import NetworkKit
import CoreKit

public protocol CharacterRemoteDataSource {

    func characters<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error>
    
    func characterDetails<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error>
}

public class CharacterRemoteDataSourceImpl: CharacterRemoteDataSource {
    
    @Dependency public var apiClient: SessionApiClient<CharactersEndpoint>
    
    public init() { }
    
    public func characters<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error> {
        guard let page = params["page"], let currentPage = Int(String(describing: page)) else {
            return Fail(error: ApiError.invalidParameter).eraseToAnyPublisher()
        }
        
        // create the request
        guard let request = apiClient.createRequest(.characters(page: currentPage)) else {
            return Fail(error: ApiError.invalidRequest).eraseToAnyPublisher()
        }
                
        // have a chance to intercept the request if needed
        //request.httpBody =
        
        // execute the request
        return try apiClient.execute(urlRequest: request)
    }
    
    public func characterDetails<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error> {
        guard let id = params["characterId"], let characterId = Int(String(describing: id)) else {
            throw ApiError.invalidParameter
        }
        // create the request
        guard let request = apiClient.createRequest(.characterDetails(characterId: characterId)) else {
            return Fail(error: ApiError.invalidRequest).eraseToAnyPublisher()
        }
        
        // have a chance to intercept the request if needed
        //request.allHTTPHeaderFields
        
        // execute the request
        return try apiClient.execute(urlRequest: request)
    }
    
}
