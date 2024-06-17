//
//  DIContainer.swift
//
//
//  Created by Sourabh Bhardwaj on 16/06/24.
//

import Foundation
import CoreKit
import NetworkKit

@testable import CharacterKit

public class DIContainer {
    public static func setupMockDepedencyContainer() {
        DependencyContainer.register(type: (any CharactersViewModel).self, CharactersViewModelImpl())
        
        DependencyContainer.register(type: (any CharacterUseCase).self, CharacterUseCaseImpl())
        
        DependencyContainer.register(type: (any CharacterRepository).self, CharacterRepositoryImpl())
        
        DependencyContainer.register(type: (any CharacterRemoteDataSource).self, CharacterRemoteDataSourceImpl())
        
        DependencyContainer.register(type: (SessionApiClient<CharactersEndpoint>).self, SessionApiClient<CharactersEndpoint>(session: MockURLSession()))
    }
}
