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
        
        let params = CharacterParameters(page: 1)
        
        do {
            // When
            let publisher: AnyPublisher<CharacterImpl, Error> = try await sut.characters(params: params)
            publisher
                .dropFirst()
                .sink { completion in
                    XCTFail("Not expected to receive success")
                } receiveValue: { characters in
                    // Then
                    XCTAssertNotNil(characters)
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch {
            DLog("Exception in testCharacterUseCase_loadingCharacters_shouldLoadWithSuccess = \(error)")
        }
    }
    
    func testCharacterUseCase_loadingCharacters_loadsNextPageWithSuccess() async {
        
        // Given
        let currentpage = 1
        
        // When
        let nextPage = sut.incrementPage(currentPage: currentpage)
        
        // Then
        XCTAssertNotEqual(currentpage, nextPage)
    }
    
    /*
    func testCharacterUseCase_loadingCharacters_shouldLoadWithWithFailure() async {
        let expectation = XCTestExpectation(description: "CharacterUseCase should not load characters")
        
        // validate mocked repository
        guard let repository = sut.repository as? CharacterRepositoryMock else { return }
        
        // Given
        let expectedError = URLError(.badServerResponse)
        repository.expectedResult = .failure(expectedError)
        
        do {
            // When
            let publisher: AnyPublisher<CharactersImpl, Error> = try await sut.characters(params: [:])
            publisher
                .dropFirst()
                .sink { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error as! URLError, expectedError)
                        expectation.fulfill()
                    }
                } receiveValue: { characters in
                    
                }
                .store(in: &cancellables)
            
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch {
            DLog("Exception in testCharacterUseCase_loadingCharacters_shouldLoadWithSuccess = \(error)")
        }
    }*/
    
    /*
    func testCharactersViewModel_loadingCharacters_withNoExpectedResultShouldThrowException() async {
        let expectation = XCTestExpectation(description: "All characters should throw an exception")
        
        // Given and When
        do {
            // When
            let publisher: AnyPublisher<CharactersImpl, Error> = try await sut.characters(params: [:])
            publisher
                .dropFirst()
                .sink { completion in
                    if case .failure(let error) = completion {
                        XCTAssertNotNil(error)
                        expectation.fulfill()
                    }
                } receiveValue: { characters in
                    
                }
                .store(in: &cancellables)
            
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch {
            DLog("Exception in testCharacterUseCase_loadingCharacters_shouldLoadWithSuccess = \(error)")
        }
    }*/

}
