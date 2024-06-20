//
//  CharacterDetailsRemoteDataSourceMock.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import Combine
import CoreKit
import NetworkKit

@testable import CharacterKit

class CharacterDetailsRemoteDataSourceMock: CharacterDetailsRemoteDataSource {
    
    var expectedResult: Result<AnyPublisher<CharacterImpl, Error>, Error>?

    func characterDetails<T>(params: CharacterDetailParameters) async throws -> AnyPublisher<T, Error> where T : Decodable {        
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
