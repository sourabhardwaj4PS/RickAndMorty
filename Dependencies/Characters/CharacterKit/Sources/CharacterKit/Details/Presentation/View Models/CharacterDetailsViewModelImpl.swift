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
    @Published public var errorMessage: String?
    
    public var isServerError: Bool = false
    public var characterId: Int
    public var character: Character?
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(characterId: Int) {
        self.characterId = characterId
    }
    
    public func loadCharacterDetails(id: Int) async {
        
        guard id > 0 else {
            DLog("Error in loadCharacterDetails - passed characterId is \(id)")
            return
        }

        let params = CharacterDetailParameters(id: id)
        do {
            let publisher: AnyPublisher<CharacterImpl, Error> = try await useCase.characterDetails(params: params)
            publisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    DLog("loadCharacterDetails completion \(completion)")
                    if case .failure(let error) = completion {
                        self.isServerError = true
                        self.errorMessage = error.localizedDescription
                    }
                    self.finishedLoading = true
                } receiveValue: { character in
                    self.character = character
                    DLog("character details received:")
                }
                .store(in: &self.cancellables)
        }
        catch let exception {
            DLog("Exception in loadCharacterDetails = \(exception)")
            self.isServerError = true
            self.finishedLoading = true
            self.errorMessage = exception.localizedDescription
        }
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
