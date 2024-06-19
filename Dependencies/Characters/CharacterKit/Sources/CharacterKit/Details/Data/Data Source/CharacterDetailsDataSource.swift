//
//  CharacterDetailsDataSource.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import CoreKit
import Combine

public protocol CharacterDetailsDataSource {
    func characterDetails<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error>
}

public protocol CharacterDetailsRemoteDataSource: CharacterDetailsDataSource { }

public protocol CharacterDetailsLocalDataSource: CharacterDetailsDataSource { }
