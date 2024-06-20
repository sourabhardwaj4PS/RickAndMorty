//
//  CharacterRepostioryTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import XCTest
import Combine
import NetworkKit
import CoreKit

@testable import CharacterKit

class CharacterRepostioryTests: XCTestCase {
    
    private var sut: CharacterRepositoryImpl!
    private var cancellables = Set<AnyCancellable>()
        
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterRepositoryImpl()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharacterRepository_loadingCharacters_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character Repository should load characters")
        
        // validate mocked data source
        guard let dataSource = sut.dataSource as? CharacterRemoteDataSourceMock else { return }
        
        // Decode JSON to Domain model and wrap in a Just publisher
        let jsonData = MockData.allCharacters
        let characters = try! JSONDecoder().decode(CharactersImpl.self, from: jsonData)
        
        // Given
        dataSource.expectedResult = .success(Just(characters).setFailureType(to: Error.self).eraseToAnyPublisher())
    
        do {
            // When
            let publisher: AnyPublisher<CharacterImpl, Error> = try await sut.characters(params: ["page": "1"])
            publisher
                .dropFirst()
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
        catch {
            DLog("Exception in testCharacterRepository_loadingCharacters_shouldLoadWithSuccess = \(error)")
        }
    }
    
}
