//
//  CharacterRepositoryImpl.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import CoreKit
import Combine

public class CharacterRepositoryImpl: CharacterRepository {
    
    @Dependency public var dataSource: CharacterDataSource
        
    public func characters<T: Decodable>(params: CharacterParameters) async throws -> AnyPublisher<T, Error> {
        return try await dataSource.characters(params: params)
    }
}
