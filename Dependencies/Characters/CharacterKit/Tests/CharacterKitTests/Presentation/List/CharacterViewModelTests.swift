//
//  CharacterViewModelTests.swift
//
//
//  Created by Sourabh Bhardwaj on 19/06/24.
//

import Foundation
import XCTest

@testable import CharacterKit

class CharacterViewModelTests: XCTestCase {
    
    var sut: CharacterViewModelImpl!
        
    override func setUpWithError() throws {
        let character = try JSONDecoder().decode(CharacterImpl.self, from: MockData.character)
        sut = CharacterViewModelImpl(character: character as Character)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharactersViewModel_character_gettersShouldReturnValid() async {
        // Given
        // sut setup with Mock character
        
        // When
        
        // Then
        XCTAssertEqual(sut.id, 2)
        XCTAssertEqual(sut.name, "Morty Smith")
        XCTAssertEqual(sut.status, "Alive")
        XCTAssertEqual(sut.species, "Human")
        XCTAssertEqual(sut.gender, "Male")
        XCTAssertEqual(sut.image, "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
        XCTAssertEqual(sut.episodesCount, 16)
    }
    
    func testCharactersViewModel_character_gettersShouldReturnEmpty() async {
        // Given
        // sut setup with Mock character
        
        // When
        sut.character = nil
        
        // Then
        XCTAssertEqual(sut.id, 0)
        XCTAssertEqual(sut.name, "")
        XCTAssertEqual(sut.status, "")
        XCTAssertEqual(sut.species, "")
        XCTAssertEqual(sut.gender, "")
        XCTAssertEqual(sut.image, "")
        XCTAssertEqual(sut.episodesCount, 0)
    }
}
