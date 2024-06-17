//
//  CharacterViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import SwiftUI

public protocol CharacterViewModel { //: Character {
    var character: Character { get set }
    //FIXME: define all attributes here again to access model attributes OR IS IT REPEATITION ??
}

public class CharacterViewModelImpl: CharacterViewModel {
//    public var id: Int
//    
//    public var name: String
//    
//    public var status: String
//    
//    public var species: String
//    
//    public var type: String
//    
//    public var gender: String
//    
//    public var image: String
//    
//    public var url: String
//    
//    public var created: String
//    
//    public var episode: [String]
//    
    public var character: Character
    
    public init(character: Character) {
        self.character = character
        
//        self.id = character.id
//        self.name = character.name
//        self.status = character.status
//        self.species = character.species
//        self.gender = character.gender
//        self.image = character.image
//        self.url = character.url
//        self.created = character.created
//        self.episode = character.episode
    }
}
