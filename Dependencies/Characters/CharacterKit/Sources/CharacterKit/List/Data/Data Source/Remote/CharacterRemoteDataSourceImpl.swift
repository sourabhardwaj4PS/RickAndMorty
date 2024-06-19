//
//  CharacterRemoteService.swift
//  
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import CoreKit
import Combine
import NetworkKit

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
    
}
