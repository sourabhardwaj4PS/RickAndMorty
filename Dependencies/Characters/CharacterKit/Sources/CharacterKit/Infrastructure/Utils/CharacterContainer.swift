//
//  CharacterContainer.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import CoreKit
import NetworkKit

public final class CharacterContainer {
    
    /**
     Sets up dependencies for abstractions with respective implementations.
     */
    public static func setupDependencies() {
        
        /// Character
        characterDependencies()
        
        /// Character details
        characterDetailsDependencies()
        
        /// Api Client
        apiClientDependencies()
    }
    
    ///
    /// Character dependencies
    ///
    private static func characterDependencies() {
        DependencyContainer.register(type: (any CharactersViewModel).self, CharactersViewModelImpl())
        
        DependencyContainer.register(type: (any CharacterUseCase).self, CharacterUseCaseImpl())
        
        DependencyContainer.register(type: (any CharacterRepository).self, CharacterRepositoryImpl())
        
        DependencyContainer.register(type: (any CharacterDataSource).self, CharacterRemoteDataSourceImpl())
    }
    
    ///
    /// Character details dependencies
    ///
    private static func characterDetailsDependencies() {
        DependencyContainer.register(type: (any CharacterDetailsUseCase).self, CharacterDetailsUseCaseImpl())
        
        DependencyContainer.register(type: (any CharacterDetailsRepository).self, CharacterDetailsRepositoryImpl())
        
        DependencyContainer.register(type: (any CharacterDetailsDataSource).self, CharacterDetailsRemoteDataSourceImpl())
    }
    
    ///
    /// Api Client dependency
    ///
    private static func apiClientDependencies() {
        let session = URLSession(configuration: .default, delegate: DefaultSessionDelegate(), delegateQueue: nil)
        DependencyContainer.register(type: (SessionApiClient<CharactersEndpoint>).self,
                                     SessionApiClient<CharactersEndpoint>(session: session))
    }

}
