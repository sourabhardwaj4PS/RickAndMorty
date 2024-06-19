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
        
        do {
            // create request
            let endpont = CharactersEndpoint.characters(page: currentPage)
            let request = try apiClient.createRequest(endpont)
            
            // execute the request
            return try apiClient.execute(urlRequest: request)
        }
        catch let exception {
            return Fail(error: exception).eraseToAnyPublisher()
        }
    }
    
    public func characterDetails<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error> {
        
        guard let id = params["characterId"], let characterId = Int(String(describing: id)) else {
            return Fail(error: ApiError.invalidParameter).eraseToAnyPublisher()
        }
        
        do {
            // create request
            let endpont = CharactersEndpoint.characterDetails(characterId: characterId)
            let request = try apiClient.createRequest(endpont)
            
            // execute the request
            return try apiClient.execute(urlRequest: request)
        }
        catch let exception {
            return Fail(error: exception).eraseToAnyPublisher()
        }
    }
    
}
