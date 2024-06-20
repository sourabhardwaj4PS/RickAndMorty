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
    
    var expectedResult: Result<AnyPublisher<CharacterImpl, Error>, Error>?

    func characterDetails<T>(params filter: Parameters) async throws -> AnyPublisher<T, Error> where T : Decodable {
        if let expectedResult = expectedResult {
            switch expectedResult {
            case .success(let publisher):
                guard let typedPublisher = publisher as? AnyPublisher<T, Error> else {
                    throw MockError.typeMismatch
                }
                return typedPublisher
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        else {
            throw URLError(.badServerResponse)
        }
    }
}
