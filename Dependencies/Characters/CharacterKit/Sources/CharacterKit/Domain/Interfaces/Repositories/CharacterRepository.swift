//
//  CharacterRepository.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import SwiftUI
import Combine
import CoreKit

public protocol CharacterRepository {
    func characters<T: Decodable>(params: CoreKit.Parameters) async throws -> AnyPublisher<T, Error>
    func characterDetails<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error>
}
