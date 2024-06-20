//
//  CharacterDetailsUseCaseTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import XCTest
import Combine
import CoreKit

@testable import CharacterKit

class CharacterDetailsUseCaseTests: XCTestCase {
    
    private var sut: CharacterDetailsUseCaseImpl!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterDetailsUseCaseImpl()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharacterDetailsUseCase_characterDetails_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character Details UseCase should load characters")
        
        // validate mocked repository
        guard let repository = sut.repository as? CharacterDetailsRepositoryMock else { return }
        
        // Decode JSON to Domain model and wrap in a Just publisher
        let jsonData = MockData.character
        let character = try! JSONDecoder().decode(CharacterImpl.self, from: jsonData)
        
        // Given
        repository.expectedResult = .success(Just(character).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        let params = CharacterDetailParameters(id: 1)

        do {
            // When
            let publisher: AnyPublisher<CharacterImpl, Error> = try await sut.characterDetails(params: params)
            publisher
                .sink { completion in
                    if case .failure(_) = completion {
                        XCTFail("Not expected to receive failure")
                    }
                } receiveValue: { character in
                    // Then
                    XCTAssertNotNil(character)
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            await fulfillment(of: [expectation], timeout: 1.0)
        }
        catch {
            DLog("Exception in testCharacterDetailsUseCase_loadingCharacters_shouldLoadWithSuccess = \(error)")
        }
    }
}
