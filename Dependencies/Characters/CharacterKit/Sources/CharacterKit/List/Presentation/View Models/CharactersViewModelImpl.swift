//
//  CharactersViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import CoreKit
import Combine

public class CharactersViewModelImpl: CharactersViewModel {
    @Dependency public var useCase: CharacterUseCase
    
    // data source for view
    @Published public var characters: [CharacterViewModel] = []
    
    // error handling
    @Published public var isServerError: Bool = false
    
    public var errorMessage: String? {
        didSet {
            isServerError = (errorMessage != nil)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() { }
    
    public func loadCharacters() {
        self.errorMessage = nil
        
        let result: Future<[Character], Error> = useCase.loadCharacters()
        process(result: result)
    }
    
    public func loadMore() {
        self.errorMessage = nil
        
        let result: Future<[Character], Error> = useCase.loadMore()
        process(result: result)
    }
    
    private func process(result: Future<[Character], Error>) {
        result
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (collection: [Character]) in
                let charactersVMcollection = collection.map { CharacterViewModelImpl(character: $0) }
                self?.characters.append(contentsOf: charactersVMcollection)
            })
            .store(in: &self.cancellables)
    }
    
}
