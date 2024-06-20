//
//  CharactersViewModelTests.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import XCTest
import NetworkKit
import Combine
import CoreKit

@testable import CharacterKit

class CharactersViewModelTests: XCTestCase {

    private var sut: CharactersViewModelImpl!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharactersViewModelImpl()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharactersViewModel_loadingCharacters_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "All characters should load successfully!")
        
        // validate mocked use case
        guard let useCase = sut.useCase as? CharacterUseCaseMock else { return }
        
        // Decode JSON to Domain model and wrap in a Just publisher
        let jsonData = MockData.allCharacters
        let characters = try! JSONDecoder().decode(CharactersImpl.self, from: jsonData)
        
        // Given
        useCase.expectedResult = .success(Just(characters).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        // When
        sut.$characters
            .dropFirst()
            .sink { characters in
                // Then
                XCTAssertNotNil(characters)
                XCTAssertEqual(characters.count, 4)
                XCTAssertEqual(characters.first?.name, "Rick")
                XCTAssertEqual(characters.last?.name, "Treudo")
                expectation.fulfill()
                
            }.store(in: &cancellables)
    
        await sut.loadCharacters()
        
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(sut.isLoading)
    }
    
    func testCharactersViewModel_loadingCharacters_shouldLoadWithFailure() async {
        let expectation = XCTestExpectation(description: "All characters should not load")
        
        // validate mocked use case
        guard let useCase = sut.useCase as? CharacterUseCaseMock else { return }
        
        // Given
        let expectedError = URLError(.badServerResponse)
        useCase.expectedResult = .failure(expectedError)
        
        // When
        sut.$errorMessage
            .dropFirst()
            .sink(receiveValue: { errorMessage in
                // Then
                XCTAssertEqual(errorMessage, expectedError.localizedDescription)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await sut.loadCharacters()
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    /*func testCharactersViewModel_loadingCharacters_withNoExpectedResultShouldThrowException() async {
        let expectation = XCTestExpectation(description: "All characters should throw an exception")
        
        // Given and When
        sut.$errorMessage
            .dropFirst()
            .sink(receiveValue: { errorMessage in
                // Then
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await sut.loadCharacters()
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }*/
    
    /*func testCharactersViewModel_loadingCharacters_shouldHandleExceptions() {
        // Given
        let invalidURL = URL(string: "invalid url")!
        var endpoint = CharactersEndpoint.characters(page: 1)
        endpoint.baseURL = invalidURL
        
        let expectation = XCTestExpectation(description: "All characters should not load")

        // When
        sut.$errorMessage
            .dropFirst()
            .sink(receiveValue: { message in
                // Then
                XCTAssertEqual(message, RequestError.invalidComponents.localizedDescription)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await sut.loadCharacters()
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }*/

//    func testCharactersViewModel_loadingCharacters_shouldValidateParameters() async {
//        
//        // Given
//        let expectation = XCTestExpectation(description: "All characters should not not because expected parameter is 'page' instead of 'invalidPage'.")
//          
//        MockURLProtocol.resetMockData()
//        MockURLProtocol.populateRequestHandler()
//        
//        // When
//        sut.$isServerError
//            .dropFirst()
//            .sink(receiveValue: { serverError in
//                // Then
//                XCTAssertTrue(serverError)
//                expectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        sut.parameters = ["invalidPage": "1"]
//        
//        await sut.loadCharacters()
//        
//        await fulfillment(of: [expectation], timeout: 1.0)
//
//        XCTAssertFalse(sut.isLoading)
//    }
    
//    func testCharactersViewModel_loadMore_shouldLoadNextPageForCharacters() async {
//        
//        // Given
//        XCTAssertEqual(sut.currentPage, 1)
//        
//        // When
//        await sut.loadCharacters()
//        
//        // Then
//        XCTAssertEqual(sut.currentPage, 2)
//    }
    
    func testNeverDecodableThrowsUnexpectedValue() {
        // Given
        let jsonData = MockData.someData
        
        // When
        XCTAssertThrowsError(try JSONDecoder().decode(NeverDecodable.self, from: jsonData)) { error in
            
            // Then it should throw DecodingError.unexpectedValue
            XCTAssertEqual(error as? DecodingError, DecodingError.unexpectedValue)
        }
    }
}
