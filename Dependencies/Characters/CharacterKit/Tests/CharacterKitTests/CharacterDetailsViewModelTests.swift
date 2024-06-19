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
    
    var sut: CharacterDetailsViewModelImpl!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterDetailsViewModelImpl(characterId: 2)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharactersViewModel_characterDetails_shouldLoadWithSuccess() async {
        // Given
        let expectedResult = MockData.character
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com/mock/character/2")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedResult)
        }
        
        let expectation = XCTestExpectation(description: "Character details loaded successfully!")
        
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
        
        // Given
        let expectation = XCTestExpectation(description: "Character details should not load")
          
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.requestFailed = true
        
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
    
    func testCharacterDetailsViewModel_characterDetails_shouldValidateCharacterId() async {
        
        // Given
        
        // When
        await sut.loadCharacterDetails(id: 0)
                
        // Then
        XCTAssertFalse(sut.finishedLoading, "Character details request should not begin because of invalid Id")
    }
    
//    func testCharacterUseCase_characterDetails_ShouldValidateParameters() async {
//        // Arrange or Given
//        
//        let expectation = XCTestExpectation(description: "Invalid parameters should fail the characterDetails request")
//          
//        MockURLProtocol.resetMockData()
//        MockURLProtocol.populateRequestHandler()
//        
//        // When
//        do {
//            try await sut.useCase.characterDetails(params: ["invalidCharacterId": "1"])
//                .receive(on: DispatchQueue.main)
//                .sink { completion in
//                    switch completion {
//                    case .finished:
//                        XCTFail("Expected an error to be received in testCharacterUseCase_characterDetails_ShouldValidateParameters")
//                    case .failure(let error):
//                        XCTAssertEqual(error as! ApiError, ApiError.invalidParameter)
//                    }
//                    expectation.fulfill()
//                } receiveValue: { (characters: NeverDecodable) in
//                    
//                }
//                .store(in: &cancellables)
//            
//            await fulfillment(of: [expectation], timeout: 1.0)
//        }
//        catch let exception {
//            print("Exception in testCharacterUseCase_characterDetails_ShouldValidateParameters = \(exception)")
//        }
//    }

    
}
