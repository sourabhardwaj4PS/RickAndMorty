//
//  CharactersUseCaseTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import XCTest
import Combine
import CoreKit

@testable import CharacterKit

class CharactersUseCaseTests: XCTestCase {
    
    private var sut: CharacterUseCaseImpl!
    private var cancellables = Set<AnyCancellable>()
        
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterUseCaseImpl()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharacterUseCase_loadingCharacters_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character UseCase should load characters")
        
        // Given
        // validate mocked repository
        guard let repository = sut.repository as? CharacterRepositoryMock else { return }
        
        // Decode JSON to Domain model and wrap in a Just publisher
        let jsonData = MockData.allCharacters
        let characters = try! JSONDecoder().decode(CharactersImpl.self, from: jsonData)
        
        repository.expectedResult = .success(Just(characters).setFailureType(to: Error.self).eraseToAnyPublisher())

        // When
        sut.loadCharacters()
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("Not expected to receive failure")
                }
            } receiveValue: { characters in
                // Then
                XCTAssertNotNil(characters)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testCharacterUseCase_loadingMoreCharacters_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character UseCase should load characters")
        
        // Given
        // validate mocked repository
        guard let repository = sut.repository as? CharacterRepositoryMock else { return }
        
        // Decode JSON to Domain model and wrap in a Just publisher
        let jsonData = MockData.allCharacters
        let characters = try! JSONDecoder().decode(CharactersImpl.self, from: jsonData)
        
        repository.expectedResult = .success(Just(characters).setFailureType(to: Error.self).eraseToAnyPublisher())

        XCTAssertEqual(sut.currentPage, 1)

        // When
        sut.loadMore()
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("Not expected to receive failure")
                }
            } receiveValue: { characters in
                XCTAssertEqual(self.sut.currentPage, 2)
                XCTAssertNotNil(characters)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }

}
