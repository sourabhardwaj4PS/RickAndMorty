//
//  CharacterDetailsDataSource.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import Combine

public protocol CharacterDetailsDataSource {
    func characterDetails<T: Decodable>(params: CharacterDetailParameters) async throws -> AnyPublisher<T, Error>
}

public protocol CharacterDetailsRemoteDataSource: CharacterDetailsDataSource { }

public protocol CharacterDetailsLocalDataSource: CharacterDetailsDataSource { }
