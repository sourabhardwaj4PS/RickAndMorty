//
//  CharacterDetailsRemoteService.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import Combine
import NetworkKit
import CoreKit

public class CharacterDetailsRemoteDataSourceImpl: CharacterDetailsRemoteDataSource {
    
    @Dependency public var apiClient: SessionApiClient<CharactersEndpoint>
    
    public init() { }
    
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
