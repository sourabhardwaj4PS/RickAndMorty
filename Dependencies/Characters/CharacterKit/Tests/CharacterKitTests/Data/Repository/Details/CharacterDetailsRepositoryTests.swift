//
//  CharacterDetailsRepositoryTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import XCTest
import Combine
import NetworkKit

@testable import CharacterKit

class CharacterDetailsRepositoryTests: XCTestCase {
    
    private var sut: CharacterDetailsRepositoryImpl!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterDetailsRepositoryImpl()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharacterDetailsRepository_characterDetails_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character Details Repository should load characters")
        
        // validate mocked data source
        guard let dataSource = sut.dataSource as? CharacterDetailsRemoteDataSourceMock else { return }
        
        // Decode JSON to Domain model and wrap in a Just publisher
        let jsonData = MockData.character
        let character = try! JSONDecoder().decode(CharacterImpl.self, from: jsonData)
        
        // Given
        dataSource.expectedResult = .success(Just(character).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        do {
            // When
            let publisher: AnyPublisher<CharacterImpl, Error> = try await sut.characterDetails(params: ["characterId":"2"])
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
            print("Exception in testCharacterDetailsRepository_characterDetails_shouldLoadWithSuccess = \(error)")
        }
    }

}
