//
//  CharacterDetailsRepository.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import SwiftUI
import Combine
import CoreKit

public protocol CharacterDetailsRepository {
    func characterDetails<T: Decodable>(params: Parameters) async throws -> AnyPublisher<T, Error>
}
