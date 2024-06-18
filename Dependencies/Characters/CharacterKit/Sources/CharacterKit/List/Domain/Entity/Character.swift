//
//  Character.swift
//
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import Foundation

public protocol Character: CharacterBase, Codable {
    var id: Int { get set }
    var name: String { get set }
    var status: String { get set }
    var species: String { get set }
    var type: String { get set }
    var gender: String { get set }
    var image: String { get set }
    var url: String { get set }
    var created: String { get set }
    var episode: [String] { get set }
}

public struct CharacterImpl: Character {
    public var id: Int
    public var name: String
    public var status: String
    public var species: String
    public var type: String
    public var gender: String
    public var image: String
    public var url: String
    public var created: String
    public var episode: [String]
}
