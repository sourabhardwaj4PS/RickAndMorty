//
//  CharactersViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation
import Combine
import CoreKit

public protocol CharactersViewModel: ObservableObject {
    
    var characters: [CharacterViewModel] { get set }
    var character: CharacterViewModel? { get set }
    var navigateToDetails: Bool { get set }
    
    // character details
    func loadCharacterDetails(id: Int) async
    func tappedCharacter(id: Int)
    
    // pagination
    var isLoading: Bool { get set }
    var currentPage: Int { get set }
    
    func shouldLoadMore(index: Int) -> Bool
    func loadMore() async
}

public class CharactersViewModelImpl: CharactersViewModel {
    @Dependency public var useCase: CharacterUseCase
    
    @Published public var characters: [CharacterViewModel] = []
    @Published public var character: CharacterViewModel?
    @Published public var navigateToDetails = false
    
    public var isLoading: Bool = false
    public var currentPage: Int = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        Task {
            await loadCharacters()
        }
    }
    
    public func loadCharacters() async {
        do {
            isLoading = true
            
            print("Loading page = \(currentPage)")
            let params: Parameters = [
                "page": "\(currentPage)"
            ]
            
            let publisher: AnyPublisher<CharactersImpl, Error> = try await useCase.characters(params: params)
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
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
    
    public func loadMore() async {
        currentPage += 1
        Task {
            await loadCharacters()
        }
    }
    
    // When scrolling arrives at the position "characters.count - 2",
    // increment currentPage, and load more data
    public func shouldLoadMore(index: Int) -> Bool {
        return index == characters.count - 2
    }
    
    public func loadCharacterDetails(id: Int) async {
        isLoading = true

        let params: Parameters = [
            "characterId": "\(id)"
        ]
        do {
            let publisher: AnyPublisher<CharacterImpl, Error> = try await useCase.characterDetails(params: params)
            publisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print("loadCharacterDetails completion \(completion)")
                    if case .failure(let error) = completion {
                        // Handle error
                        print("Failed to load characters: \(error)")
                    }
                    else {
                        self.isLoading = false
                    }
                } receiveValue: { character in
                    let characterVM = CharacterViewModelImpl(character: character)
                    print("character details received:")
                    print("Name: \(characterVM.character.name)")
                    self.character = characterVM
                    self.navigateToDetails = true
                }
                .store(in: &self.cancellables)
        }
        catch let exception {
            print("Exception in loadCharacterDetails = \(exception)")
        }
    }
    
    public func tappedCharacter(id: Int) {
        print("character tapped")
        Task {
            await loadCharacterDetails(id: id)
        }
    }
}
