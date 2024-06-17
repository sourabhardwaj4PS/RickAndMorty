//
//  CharactersApp.swift
//  Characters
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import SwiftUI
import CharacterKit
import CoreKit
import NetworkKit

@main
struct CharactersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        setupDependencyContainer()
    }
    
}

extension CharactersApp {
    
    func setupDependencyContainer() {
        DependencyContainer.register(type: (any CharactersViewModel).self, CharactersViewModelImpl())
        
        DependencyContainer.register(type: (any CharacterUseCase).self, CharacterUseCaseImpl())
        
        DependencyContainer.register(type: (any CharacterRepository).self, CharacterRepositoryImpl())
        
        DependencyContainer.register(type: (any CharacterRemoteDataSource).self, CharacterRemoteDataSourceImpl())
        
        DependencyContainer.register(type: (SessionApiClient<CharactersEndpoint>).self, SessionApiClient<CharactersEndpoint>(session: URLSession.shared))
    }
}
