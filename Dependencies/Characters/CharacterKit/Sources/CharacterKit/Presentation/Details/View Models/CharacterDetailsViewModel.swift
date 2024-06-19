//
//  CharacterDetailsViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 18/06/24.
//

import Foundation
import Combine
import CoreKit

public protocol PublishableCharacterDetails: ObservableObject {
    var finishedLoading: Bool { get set }
    
    // error handling
    var isServerError: Bool { get set }
    var errorMessage: String { get set }
}

public protocol NetworkableCharacterDetails {
    var parameters: Parameters? { get set }
    
    func loadCharacterDetails(id: Int) async
}

public protocol AttributableCharacter {
    var name: String { get }
    var status: String { get }
    var species: String { get }
    var type: String { get }
    var gender: String { get }
    var image: String { get }
    var url: String { get }
    var created: String { get }
    var episode: [String] { get }
}

public protocol CharacterDetailsViewModel: PublishableCharacterDetails, NetworkableCharacterDetails, AttributableCharacter {
    var characterId: Int { get set }
}

public class CharacterDetailsViewModelImpl: CharacterDetailsViewModel {
    @Dependency public var useCase: CharacterUseCase
    
    @Published public var finishedLoading: Bool = false
    @Published public var isServerError: Bool = false
    @Published public var errorMessage: String = ""
    
    public var parameters: Parameters?
    public var characterId: Int
    
    private var cancellables = Set<AnyCancellable>()
    private var character: Character?
    
    public init(characterId: Int) {
        self.characterId = characterId
    }
    
    public func loadCharacterDetails(id: Int) async {
        
        guard id > 0 else {
            print("Error in loadCharacterDetails - passed characterId is \(id)")
            return
        }

        let params: Parameters = [
            "characterId": "\(id)"
        ]
        do {
            let publisher: AnyPublisher<CharacterImpl, Error> = try await useCase.characterDetails(params: parameters ?? params)
            publisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print("loadCharacterDetails completion \(completion)")
                    if case .failure(let error) = completion {
                        self.isServerError = true
                        self.errorMessage = error.localizedDescription
                    }
                    self.finishedLoading = true
                } receiveValue: { character in
                    self.character = character
                    print("character details received:")
                }
                .store(in: &self.cancellables)
        }
        catch let exception {
            print("Exception in loadCharacterDetails = \(exception)")
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
