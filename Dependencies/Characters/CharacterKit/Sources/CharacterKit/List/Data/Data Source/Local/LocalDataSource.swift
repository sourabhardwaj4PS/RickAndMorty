//
//  CharacterLocalDataSource.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation

public protocol CharacterLocalDataSource {
    func save(character: [Character]) -> Bool
    
    func characters(page: Int) throws -> Characters?
    
    func characterDetails(characterId: Int) throws -> Character?
}

public class CharacterLocalDataSourceImpl: CharacterLocalDataSource {
    
    public func save(character: [Character]) -> Bool {
        return false
    }
    
    public func characters(page: Int) throws -> Characters? {
        return nil
    }
    
    public func characterDetails(characterId: Int) throws -> Character? {
        return nil
    }
        
}
