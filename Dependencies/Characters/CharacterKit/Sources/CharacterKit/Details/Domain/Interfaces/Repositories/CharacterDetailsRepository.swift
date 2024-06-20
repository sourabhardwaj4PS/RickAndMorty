//
//  CharacterDetailsRepository.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import SwiftUI
import Combine

public protocol CharacterDetailsRepository {
    func characterDetails<T: Decodable>(params: CharacterDetailParameters) async throws -> AnyPublisher<T, Error>
}
