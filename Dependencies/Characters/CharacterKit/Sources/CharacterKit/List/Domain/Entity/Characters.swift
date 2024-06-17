//
//  Characters.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation

public protocol Characters: CharacterBase, Codable {
    var info: CharacterInfo { get set }
    var results: [Character] { get set }
}

//public protocol Characters: Codable {
//    associatedtype C: Character
//    associatedtype CI: CharacterInfo
//
//    var info: CI { get set }
//    var results: [C] { get set }
//}
//
//public struct CharactersImpl<C: Character, CI: CharacterInfo>: Characters {
//    public var info: CI
//    public var results: [C]
//}

public struct CharactersImpl: Characters {
    public var info: CharacterInfo
    public var results: [Character]
    
    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
    
    public init(info: CharacterInfo, results: [Character]) {
        self.info = info
        self.results = results
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        info = try values.decode(CharacterInfoImpl.self, forKey: .info)
        results = try values.decode([CharacterImpl].self, forKey: .results)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(info, forKey: .info)
        
        // FIXME: why this is complaining?
        //try container.encode(results, forKey: .results)
    }
}
