//
//  CharacterDetailsViewModelTests.swift
//
//
//  Created by Sourabh Bhardwaj on 18/06/24.
//

import Foundation
import XCTest
import NetworkKit
import Combine

@testable import CharacterKit

class CharacterDetailsViewModelTests: XCTestCase {
    
    private var sut: CharacterDetailsViewModelImpl!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterDetailsViewModelImpl(characterId: 2)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharactersViewModel_characterDetails_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character details should loaded successfully")

        // validate mocked use case
        guard let useCase = sut.useCase as? CharacterDetailsUseCaseMock else { return }

        // Decode JSON to Domain model and wrap in a Just publisher
        let jsonData = MockData.character
        let character = try! JSONDecoder().decode(CharacterImpl.self, from: jsonData)
        
        // Given
        useCase.expectedResult = .success(Just(character).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        // When
        sut.$finishedLoading
            .dropFirst()
            .sink { [self] finished in
                // Then
                XCTAssertTrue(finished)
                
                XCTAssertEqual(sut.name, "Morty Smith")
                XCTAssertEqual(sut.status, "Alive")
                XCTAssertEqual(sut.species, "Human")
                XCTAssertEqual(sut.type, "")
                XCTAssertEqual(sut.gender, "Male")
                XCTAssertEqual(sut.image, "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
                XCTAssertEqual(sut.url, "https://rickandmortyapi.com/api/character/2")
                XCTAssertEqual(sut.created, "2017-11-04T18:50:21.651Z")
                XCTAssertEqual(sut.episode.count, 16)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.loadCharacterDetails(id: 2)
        
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertTrue(sut.finishedLoading)
    }
    
    func testCharactersViewModel_characterDetails_shouldLoadWithFailure() async {
        let expectation = XCTestExpectation(description: "Character details should not load")
        
        // validate mocked use case
        guard let useCase = sut.useCase as? CharacterDetailsUseCaseMock else { return }
        
        // Given
        let expectedError = URLError(.badServerResponse)
        useCase.expectedResult = .failure(expectedError)
        
        // When
        sut.$finishedLoading
            .dropFirst()
            .sink { [self] finished in
                
                // Then
                XCTAssertTrue(sut.isServerError)
                XCTAssertEqual(sut.name, "")
                XCTAssertEqual(sut.status, "")
                XCTAssertEqual(sut.species, "")
                XCTAssertEqual(sut.type, "")
                XCTAssertEqual(sut.gender, "")
                XCTAssertEqual(sut.image, "")
                XCTAssertEqual(sut.url, "")
                XCTAssertEqual(sut.created, "")
                XCTAssertEqual(sut.episode.count, 0)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.loadCharacterDetails(id: 2)
        
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertTrue(sut.finishedLoading)        
    }
    
    func testCharactersViewModel_characterDetails_withNoExpectedResultShouldThrowException() async {
        let expectation = XCTestExpectation(description: "Characters details should throw an exception")
        
        // Given and When
        sut.$errorMessage
            .dropFirst()
            .sink(receiveValue: { errorMessage in
                // Then
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await sut.loadCharacterDetails(id: 2)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
}
