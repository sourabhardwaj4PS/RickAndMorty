//
//  CharacterRemoteDataSourceMock.swift
//  
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import Combine
import CoreKit
import NetworkKit

@testable import CharacterKit

class CharacterRemoteDataSourceMock: CharacterRemoteDataSource {
    
    var expectedResult: Result<AnyPublisher<CharactersImpl, Error>, Error>?
    
    func characters<T>(params filter: Parameters) async throws -> AnyPublisher<T, Error> where T : Decodable {
        guard let page = filter["page"], let _ = Int(String(describing: page)) else {
            return Fail(error: ApiError.invalidParameter).eraseToAnyPublisher()
        }
        
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
