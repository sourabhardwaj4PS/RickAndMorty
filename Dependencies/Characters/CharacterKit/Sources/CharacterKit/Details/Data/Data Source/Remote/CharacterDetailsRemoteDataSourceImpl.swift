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
        
    public func characterDetails<T: Decodable>(params: CharacterDetailParameters) async throws -> AnyPublisher<T, Error> {
        do {
            // create request
            let endpont = CharactersEndpoint.characterDetails(characterId: params.id)
            let request = try apiClient.createRequest(endpont)
            DLog(request.log())
            
            // execute the request
            return try apiClient.execute(urlRequest: request)
        }
        catch let exception {
            return Fail(error: exception).eraseToAnyPublisher()
        }
    }
    
}
