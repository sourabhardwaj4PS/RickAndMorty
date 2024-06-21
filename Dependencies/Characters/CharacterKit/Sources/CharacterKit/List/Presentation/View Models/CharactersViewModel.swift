//
//  CharactersViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import CoreKit
/**
 A protocol that combines functionality related to character details.
 */
public protocol CharactersViewModel: ObservableObject {
    
    // data source for view
    var characters: [CharacterViewModel] { get set }
    
    // error handling
    var errorMessage: String? { get set }
    var isServerError: Bool { get set }
    
    // callers
    func loadCharacters()
    func loadMore()
}
