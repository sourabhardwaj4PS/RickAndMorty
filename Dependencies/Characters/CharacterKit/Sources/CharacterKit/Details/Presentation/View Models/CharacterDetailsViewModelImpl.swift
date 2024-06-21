//
//  CharacterDetailsViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 18/06/24.
//

import Foundation
import Combine
import CoreKit

public class CharacterDetailsViewModelImpl: CharacterDetailsViewModel {
    @Dependency public var useCase: CharacterDetailsUseCase
    
    @Published public var finishedLoading: Bool = false
    
    public var errorMessage: String? {
        didSet {
            isServerError = (errorMessage != nil)
        }
    }
    
    public var isServerError: Bool = false
    public var character: Character?
    
    private var cancellables = Set<AnyCancellable>()
    
    public var characterId: Int
    public init(characterId: Int) {
        self.characterId = characterId
    }
    
    public func loadCharacterDetails(id: Int) {
        self.errorMessage = nil
        
        useCase.loadCharacterDetails(characterId: id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
                self.finishedLoading = true
            } receiveValue: { character in
                self.character = character
                DLog("Character details received.")
            }
            .store(in: &self.cancellables)
    }
    
}


extension CharacterDetailsViewModelImpl: AttributableCharacter {
    public var name: String { return character?.name ?? "" }
    public var status: String { return character?.status ?? "" }
    public var species: String { return character?.species ?? "" }
    public var type: String { return character?.type ?? "" }
    public var gender: String { return character?.gender ?? "" }
    public var image: String { return character?.image ?? "" }
    public var url: String { return character?.url ?? "" }
    public var created: String { return character?.created ?? "" }
    public var episode: [String] { return character?.episode ?? [] }
}
