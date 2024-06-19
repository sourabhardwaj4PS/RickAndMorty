//
//  CharacterDetailsViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 18/06/24.
//

import Foundation
import Combine
import CoreKit

public protocol CharacterDetailsViewModel: ObservableObject {
    
    var characterId: Int { get set }
    
    var finishedLoading: Bool { get set }
    var character: Character? { get set }

    // error handling
    var isServerError: Bool { get set }
    var errorMessage: String { get set }
    
    // attributes to access
    var name: String { get }
    var status: String { get }
    var species: String { get }
    var type: String { get }
    var gender: String { get }
    var image: String { get }
    var url: String { get }
    var created: String { get }
    var episode: [String] { get }
    
    // to make server call
    var parameters: Parameters? { get set }
    func loadCharacterDetails(id: Int) async
}

public class CharacterDetailsViewModelImpl: CharacterDetailsViewModel {
    @Dependency public var useCase: CharacterUseCase
    
    // error handling
    @Published public var isServerError: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var finishedLoading: Bool = false
    
    public var character: Character?
    
    private var cancellables = Set<AnyCancellable>()
    public var characterId: Int
    
    public var parameters: Parameters?
    
    // getters
    public var name: String { return character?.name ?? "" }
    public var status: String { return character?.status ?? "" }
    public var species: String { return character?.species ?? "" }
    public var type: String { return character?.type ?? "" }
    public var gender: String { return character?.gender ?? "" }
    public var image: String { return character?.image ?? "" }
    public var url: String { return character?.url ?? "" }
    public var created: String { return character?.created ?? "" }
    public var episode: [String] { return character?.episode ?? [] }
    
    public init(characterId: Int) {
        self.characterId = characterId
        print("CharacterDetailsViewModelImpl init")
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
