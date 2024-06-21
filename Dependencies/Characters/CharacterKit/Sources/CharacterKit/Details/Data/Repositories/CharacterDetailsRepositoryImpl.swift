//
//  CharacterDetailsRepositoryImpl.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import CoreKit
import Combine

public class CharacterDetailsRepositoryImpl: CharacterDetailsRepository {
    
    @Dependency public var dataSource: CharacterDetailsDataSource
        
    public func characterDetails<T: Decodable>(params: CharacterDetailParameters) async throws -> AnyPublisher<T, Error> {
        return try await dataSource.characterDetails(params: params)
    }
}
