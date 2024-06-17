//
//  PreviewCharactersViewModelImpl.swift
//
//
//  Created by Sourabh Bhardwaj on 17/06/24.
//

import Foundation
import Combine
import CoreKit

class PreviewCharactersViewModelImpl: CharactersViewModel {
    func loadCharacterDetails(id: Int) async {
        // do something
    }
    
    @Published public var characters: [CharacterViewModel] = [
        CharacterViewModelImpl(character: CharacterImpl(id: 1, name: "Rick Sanchez", status: "Alive", species: "Cartoon", type: "", gender: "Male", image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 2, name: "Citadel of Ricks", status: "Alive", species: "Cartoon", type: "", gender: "Male", image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 3, name: "Summer Smith", status: "Alive", species: "Humanoid", type: "", gender: "Unknown", image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 4, name: "Beth Smith", status: "Alive", species: "Cartoon", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 5, name: "Jerry Smith", status: "Alive", species: "Human", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 6, name: "Abadango Cluster Princess Cluster Princess Abadango ", status: "Alive", species: "Cartoon", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/6.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 7, name: "Abradolf Lincler", status: "Unknown", species: "Alien", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/7.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 8, name: "Adjudicator Rick", status: "Dead", species: "Human", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/8.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 9, name: "Agency Director", status: "Dead", species: "Human", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/9.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 10, name: "Alan Rails", status: "Dead", species: "Human", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/10.jpeg", url: "none", created: "NA", episode: [])),
        CharacterViewModelImpl(character: CharacterImpl(id: 11, name: "Albert Einstein", status: "Dead", species: "Human", type: "", gender: "Female", image: "https://rickandmortyapi.com/api/character/avatar/11.jpeg", url: "none", created: "NA", episode: []))
    ]

    func tapped(viewModel: CharacterViewModel) {
        print("CharactersVM Preview:: tapped \(viewModel.character.name) ")
    }
    
    var isLoading: Bool = false
    
    var currentPage: Int = 1
    
    func shouldLoadMore(index: Int) -> Bool {
        return index == characters.count - 2
    }
    
    func loadMore() async {
        print("CharactersVM Preview:: load more called..")
    }
    
    
}
