//
//  CharacterRemoteDataSourceTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import XCTest
import Combine
import NetworkKit

@testable import CharacterKit

class CharacterRemoteDataSourceTests: XCTestCase {
    
    private var sut: CharacterRemoteDataSourceImpl!
    private var cancellables = Set<AnyCancellable>()
        
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterRemoteDataSourceImpl()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharacterRemoteDataSource_loadingCharacters_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character Remote Data Source should load characters")
        
        // Given
        let expectedResult = MockData.allCharacters
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com/mock/character")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedResult)
        }
        
        let params = CharacterParameters(page: 1)

        do {
            // When
            let publisher: AnyPublisher<CharactersImpl, Error> = try await sut.characters(params: params)
            publisher
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
            print("Exception in testCharacterRemoteDataSource_loadingCharacters_shouldLoadWithSuccess = \(error)")
        }
    }
    
}
