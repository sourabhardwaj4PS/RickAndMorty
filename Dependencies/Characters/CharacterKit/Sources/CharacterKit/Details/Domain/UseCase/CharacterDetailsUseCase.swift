//
//  CharacterDetailsUseCase.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import Combine
import CoreKit

public protocol CharacterDetailsUseCase {
    var isLoading: Bool { get set }
    
    func loadCharacterDetails(characterId: Int) -> Future<Character, Error>
}

public class CharacterDetailsUseCaseImpl: CharacterDetailsUseCase {
    @Dependency public var repository: CharacterDetailsRepository
    
    public var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() { }
    
    public func loadCharacterDetails(characterId: Int) -> Future<Character, Error> {
        return Future<Character, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RequestErrors.selfObjectMissing))
                return
            }
            
            guard !self.isLoading else {
                promise(.failure(RequestErrors.alreadyInProgress))
                return
            }
            
            self.isLoading = true
            DLog("Loading character details for ID = \(characterId)")
            
            let params = CharacterDetailParameters(id: characterId)
            
            Task {
                do {
                    let publisher: AnyPublisher<CharacterImpl, Error> = try await self.repository.characterDetails(params: params)
                    publisher
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                promise(.failure(error))
                            case .finished:
                                break
                            }
                        }, receiveValue: { character in
                            promise(.success(character))
                        })
                        .store(in: &self.cancellables)
                    self.isLoading = false
                } catch let error {
                    DLog("Exception in loadCharacterDetails = \(error)")
                    self.isLoading = false
                    promise(.failure(error))
                }
            }
        }
    }
}

