//
//  CharacterRepository.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import SwiftUI
import Combine

public protocol CharacterRepository {
    func characters<T: Decodable>(params: CharacterParameters) async throws -> AnyPublisher<T, Error>
}
