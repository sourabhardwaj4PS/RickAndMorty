//
//  CharacterDetailsViewModel.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import CoreKit

/**
 A protocol for objects that handle the publishable character details.
 */
public protocol PublishableCharacterDetails: ObservableObject {
    var finishedLoading: Bool { get set }
    
    // error handling
    var isServerError: Bool { get set }
    var errorMessage: String { get set }
}

/**
 A protocol for objects that handle network operations related to character details.
 */
public protocol NetworkableCharacterDetails {
    var parameters: Parameters? { get set }
    
    func loadCharacterDetails(id: Int) async
}

/**
 A protocol for objects that define attributes of a character.
 */
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

/**
 A protocol that combines functionality related to character details.
 */
public protocol CharacterDetailsViewModel: PublishableCharacterDetails, NetworkableCharacterDetails, AttributableCharacter {
    var characterId: Int { get set }
}
