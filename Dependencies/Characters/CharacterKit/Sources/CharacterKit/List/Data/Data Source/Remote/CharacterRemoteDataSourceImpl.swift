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
        
    public func characters<T: Decodable>(params: CharacterParameters) async throws -> AnyPublisher<T, Error> {
        do {
            // create request
            let endpont = CharactersEndpoint.characters(page: params.page)
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
