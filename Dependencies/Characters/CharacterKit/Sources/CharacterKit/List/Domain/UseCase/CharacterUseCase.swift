//
//  CharactersUseCase.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import Combine
import CoreKit

public protocol CharacterUseCase {
    var currentPage: Int { get set }
    var isLoading: Bool { get set }
    
    func loadMore() -> Future<[Character], Error>
    func loadCharacters() -> Future<[Character], Error>
}

enum RequestErrors: Error {
    case alreadyInProgress
    case selfObjectMissing
}

public class CharacterUseCaseImpl: CharacterUseCase {
    @Dependency public var repository: CharacterRepository
    
    public var isLoading: Bool = false
    public var currentPage: Int = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() { }
    
    public func loadCharacters() -> Future<[Character], Error> {
        return Future<[Character], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RequestErrors.selfObjectMissing))
                return
            }
            
            guard !self.isLoading else {
                promise(.failure(RequestErrors.alreadyInProgress))
                return
            }
            
            self.isLoading = true
            DLog("Loading page = \(self.currentPage)")
            
            let params = CharacterParameters(page: self.currentPage)
            
            Task {
                do {
                    let publisher: AnyPublisher<CharactersImpl, Error> = try await self.repository.characters(params: params)
                    publisher
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                promise(.failure(error))
                            case .finished:
                                break
                            }
                        }, receiveValue: { characters in
                            promise(.success(characters.results))
                        })
                        .store(in: &self.cancellables)
                    self.isLoading = false
                } catch let error {
                    DLog("Exception in loadCharacters = \(error)")
                    self.isLoading = false
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func loadMore() -> Future<[Character], Error> {
        currentPage += 1
        return loadCharacters()
    }
    
}

