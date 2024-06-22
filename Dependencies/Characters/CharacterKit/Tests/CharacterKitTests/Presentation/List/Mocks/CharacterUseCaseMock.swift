//
//  CharacterUseCaseMock.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import Combine
import CoreKit

@testable import CharacterKit

enum MockError: Error {
    case typeMismatch
}

class CharacterUseCaseMock: CharacterUseCase {
    var currentPage: Int = 1
    
    var isLoading: Bool = false
    
    var expectedResult: Result<CharactersImpl, Error>?
    
    func loadCharacters() -> Future<[Character], Error> {
        return Future<[Character], Error> { promise in
            
            if let expectedResult = self.expectedResult {
                switch expectedResult {
                case .success(let character):
                    promise(.success(character.results))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
            else {
                promise(.failure(URLError(.badServerResponse)))
            }
        }
    }
    
    func loadMore() -> Future<[Character], Error> {
        currentPage += 1
        return loadCharacters()
    }
    
    
}
