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
    @Published public var hasAppeared: Bool = false
    
    // error handling
    @Published public var errorMessage: String?
    
    public var isServerError: Bool = false
    public var isLoading: Bool = false
    
    public var currentPage: Int = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    public func loadCharacters() async {
        do {
            guard !isLoading else { return }
            
            isLoading = true
            DLog("Loading page = \(currentPage)")
            
            let params = CharacterParameters(page: currentPage)
            
            let publisher: AnyPublisher<CharactersImpl, Error> = try await useCase.characters(params: params)
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
                    
                    // prepare the viewmodel for the view
                    let characterVM = characters.results.map { CharacterViewModelImpl(character: $0) }
                    self.characters.append(contentsOf: characterVM)
                    
                    // increment the page for next load
                    currentPage = useCase.incrementPage(currentPage: currentPage)
                })
                .store(in: &self.cancellables)
        }
        catch let exception {
            DLog("Exception in loadCharacters = \(exception)")
            self.isLoading = false
            self.isServerError = true
            self.errorMessage = exception.localizedDescription
        }
    }
}
