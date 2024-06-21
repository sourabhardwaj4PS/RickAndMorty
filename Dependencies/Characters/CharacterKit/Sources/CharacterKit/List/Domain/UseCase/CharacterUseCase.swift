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
    func characters<T: Decodable>(params: CharacterParameters) async throws -> AnyPublisher<T, Error>
    func incrementPage(currentPage: Int) -> Int
}

public class CharacterUseCaseImpl: CharacterUseCase {
    @Dependency public var repository: CharacterRepository
        
    public func characters<T: Decodable>(params: CharacterParameters) async throws -> AnyPublisher<T, Error> {
        return try await repository.characters(params: params)
    }
    
    public func incrementPage(currentPage: Int) -> Int {
        return currentPage + 1
    }
}
