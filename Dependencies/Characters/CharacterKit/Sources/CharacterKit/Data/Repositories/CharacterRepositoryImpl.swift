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
    
    @Dependency public var dataSource: CharacterRemoteDataSource
    
    public init() { }
    
    public func characters<T: Decodable>(params: CoreKit.Parameters) async throws -> AnyPublisher<T, Error> {
        return try await dataSource.characters(params: params)
    }
    
    public func characterDetails<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error> {
        return try await dataSource.characterDetails(params: params)
    }
}
