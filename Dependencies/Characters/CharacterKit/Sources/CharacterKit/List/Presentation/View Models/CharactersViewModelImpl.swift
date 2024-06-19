//
//  CharactersViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import Combine
import CoreKit

public class CharactersViewModelImpl: CharactersViewModel {
    @Dependency public var useCase: CharacterUseCase
    
    @Published public var characters: [CharacterViewModel] = []
    
    // error handling
    @Published public var isServerError = false
    @Published public var errorMessage = ""
    
    public var isLoading: Bool = false
    public var currentPage: Int = 1
    public var parameters: Parameters?
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(isTestEnvironment: Bool = false) {
        if !isTestEnvironment {
            Task {
                await loadCharacters()
            }
        }
    }
    
    public func loadCharacters() async {
        do {
            guard !isLoading else { return }
            
            isLoading = true
            
            print("Loading page = \(currentPage)")
            let params: Parameters = [
                "page": "\(currentPage)"
            ]
            
            let publisher: AnyPublisher<CharactersImpl, Error> = try await useCase.characters(params: parameters ?? params)
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    if case .failure(let error) = completion {
                        self.isServerError = true
                        self.errorMessage = error.localizedDescription
                    }
                    self.isLoading = false
                }, receiveValue: { [weak self] characters in
                    guard let self = self else { return }
                    let characterVM = characters.results.map { CharacterViewModelImpl(character: $0) }
                    self.characters.append(contentsOf: characterVM)
                })
                .store(in: &self.cancellables)
        }
        catch let exception {
            print("Exception in loadCharacters = \(exception)")
        }
    }

    // Increments currentPage, and load more characters
    public func loadMore() async {
        currentPage += 1
        Task {
            await loadCharacters()
        }
    }
    
    // When scrolling arrives at the position "characters.count - 2", call loadMore
    public func shouldLoadMore(index: Int) -> Bool {
        return index == characters.count - 2
    }
}
