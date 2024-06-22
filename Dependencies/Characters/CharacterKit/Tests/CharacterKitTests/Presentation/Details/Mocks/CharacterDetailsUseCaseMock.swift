//
//  CharacterDetailsUseCaseMock.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import Combine
import CoreKit

@testable import CharacterKit

class CharacterDetailsUseCaseMock: CharacterDetailsUseCase {
    var isLoading: Bool = false
    
    var expectedResult: Result<CharacterImpl, Error>?

    public func loadCharacterDetails(characterId: Int) -> Future<Character, Error> {
        return Future<Character, Error> { promise in
            
            if let expectedResult = self.expectedResult {
                switch expectedResult {
                case .success(let character):
                    promise(.success(character))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
            else {
                promise(.failure(URLError(.badServerResponse)))
            }
        }
    }
    
}
