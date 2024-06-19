//
//  CharactersUseCase.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import Combine
import CoreKit

public protocol CharacterUseCase {
    func characters<T: Decodable>(params filter: Parameters) async throws -> AnyPublisher<T, Error>
    func characterDetails<T: Decodable>(params filter: Parameters) async throws -> AnyPublisher<T, Error>
}

public class CharacterUseCaseImpl: CharacterUseCase {
    @Dependency public var repository: CharacterRepository
    
    public init() { }
    
    public func characters<T: Decodable>(params filter: Parameters) async throws -> AnyPublisher<T, Error> {
        return try await repository.characters(params: filter)
    }
    
    public func characterDetails<T: Decodable>(params filter: Parameters) async throws -> AnyPublisher<T, Error> {
        return try await repository.characterDetails(params: filter)
    }
}
