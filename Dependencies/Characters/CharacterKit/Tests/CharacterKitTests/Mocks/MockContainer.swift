//
//  MockContainer.swift
//
//
//  Created by Sourabh Bhardwaj on 16/06/24.
//

import Foundation
import CoreKit
import NetworkKit

@testable import CharacterKit

public class MockContainer {
    
    public static func setupMockDependencies() {
        DependencyContainer.register(type: (any CharactersViewModel).self, CharactersViewModelImpl(isTestEnvironment: true))
        
        DependencyContainer.register(type: (any CharacterUseCase).self, CharacterUseCaseImpl())
        
        DependencyContainer.register(type: (any CharacterRepository).self, CharacterRepositoryImpl())
        
        DependencyContainer.register(type: (any CharacterRemoteDataSource).self, CharacterRemoteDataSourceImpl())
        
        DependencyContainer.register(type: (SessionApiClient<CharactersEndpoint>).self, SessionApiClient<CharactersEndpoint>(session: MockURLSession()))
    }
}
