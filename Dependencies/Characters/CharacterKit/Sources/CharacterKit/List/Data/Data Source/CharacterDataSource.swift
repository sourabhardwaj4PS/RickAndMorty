//
//  CharacterDataSource.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import CoreKit
import Combine

public protocol CharacterDataSource {
    func characters<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error>
}

public protocol CharacterRemoteDataSource: CharacterDataSource { }

public protocol CharacterLocalDataSource: CharacterDataSource { }
