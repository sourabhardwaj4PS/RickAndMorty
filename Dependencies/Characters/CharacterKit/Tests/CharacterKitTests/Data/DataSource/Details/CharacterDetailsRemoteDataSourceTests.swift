//
//  CharacterDetailsRemoteDataSourceTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import XCTest
import Combine
import NetworkKit

@testable import CharacterKit

class CharacterDetailsRemoteDataSourceTests: XCTestCase {
    
    private var sut: CharacterDetailsRemoteDataSourceImpl!
    private var cancellables = Set<AnyCancellable>()
        
    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
        
        sut = CharacterDetailsRemoteDataSourceImpl()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCharacterDetailsRemoteDataSource_characterDetails_shouldLoadWithSuccess() async {
        let expectation = XCTestExpectation(description: "Character Details Remote Data Source should load characters")
        
        // Given
        let expectedResult = MockData.character
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://example.com/mock/character")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedResult)
        }
        
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
            print("Exception in testCharacterDetailsRemoteDataSource_characterDetails_shouldLoadWithSuccess = \(error)")
        }
    }
}
