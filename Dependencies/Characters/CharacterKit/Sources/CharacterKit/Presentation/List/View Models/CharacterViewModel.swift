//
//  CharacterViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation

public protocol CharacterViewModel {
    var character: Character? { get set }
    
    // attributes to access
    var id: Int { get }
    var name: String { get }
    var gender: String { get }
    var status: String { get }
    var species: String { get }
    var image: String { get }
    var episodesCount: Int { get }
}

public class CharacterViewModelImpl: CharacterViewModel {
    public var character: Character?
    
    // getters
    public var id: Int { return character?.id ?? 0 }
    public var name: String { return character?.name ?? "" }
    public var gender: String { return character?.gender ?? "" }
    public var status: String { return character?.status ?? "" }
    public var species: String { return character?.species ?? "" }
    public var image: String { return character?.image ?? "" }
    public var episodesCount: Int { return character?.episode.count ?? 0 }
    
    // initializer
    public init(character: Character) {
        self.character = character
    }
}
