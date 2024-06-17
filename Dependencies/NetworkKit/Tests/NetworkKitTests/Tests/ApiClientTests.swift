//
//  ApiClientTests.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import XCTest
import Combine

@testable import NetworkKit

final class ApiClientTests: XCTestCase {
    
    // MARK: Properties
    //var cancellables = Set<AnyCancellable>()
    private var apiClient: URLSessionApiClient<MockEndpoint>?

    // MARK: - Setup and TearDown
    override func setUp() {
        super.setUp()
        apiClient = URLSessionApiClient<MockEndpoint>(session: MockURLSession())
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    // MARK: - Request Validation
    func testCreateRequest() {
        // Given
        let endpoint = MockEndpoint.characters(page: 1)
        
        // When
        let request = apiClient?.createRequest(endpoint)
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://mocked.com/api/character/?page=1")
        XCTAssertEqual(request?.httpMethod, "GET")
    }
    
    func testCreateRequest_WithHeaders() {
        // validate request creation
        guard let request = apiClient?.createRequest(.characters(page: 1)) else {
            XCTFail("Failed to create URLRequest")
            return
        }
        
        // Assertions
        XCTAssertEqual(request.url?.absoluteString, "https://mocked.com/api/character/?page=1")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer-Mocked ABCDEFG123456")
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
    }
    
    
    // MARK: - Executing Request
    func testRequestSuccess() throws {
        // Given
        let expectedCharacter = MockCharacter(id: 1,
                                              name: "Rick and Morty",
                                              image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        
        let expectedResult = ApiResult(status: "success", data: expectedCharacter)
        
        
        let data = try XCTUnwrap(JSONEncoder().encode(expectedResult))
        let expectation = XCTestExpectation(description: "Request done successfully!")
          
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        guard let request = apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
        _ = try apiClient?.execute(urlRequest: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("Unexpected failure: \(error)")
                }
            }, receiveValue: { (response: ApiResult<MockCharacter>) in
                // Then
                XCTAssertTrue(response.success)
                XCTAssertEqual(response.data, expectedCharacter)
                expectation.fulfill()
            })
        
        // Complete the expectation
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testRequestFailureCustomError() throws {
        // Given
        let expectation = XCTestExpectation(description: "Request failed!")
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 422, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When
        guard let request = apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
        _ = try apiClient?.execute(urlRequest: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error as! ApiError, ApiError.customError(statusCode: 422))
                    expectation.fulfill()
                }
            }, receiveValue: { (response: ApiResult<MockCharacter>) in
                XCTFail("Unexpected response \(response.success)")
            })
        
        // Complete the expectation
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestFailureDecodingFailed() throws {
        // Given
        let expectation = XCTestExpectation(description: "Request failed!")
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.decodingFailed = true

        // When
        guard let request = apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
        _ = try apiClient?.execute(urlRequest: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error as! ApiError, ApiError.decodingFailed)
                    expectation.fulfill()
                }
            }, receiveValue: { (response: ApiResult<MockCharacter>) in
                XCTFail("Unexpected response \(response.success)")
            })
        
        // Complete the expectation
        wait(for: [expectation], timeout: 1)
    }
    
    func testRequestFailureRequestFailed() throws {
        // Given
        let expectation = XCTestExpectation(description: "Request failed!")
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.requestFailed = true

        // When
        guard let request = apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
        _ = try apiClient?.execute(urlRequest: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error as! ApiError, ApiError.requestFailed)
                    expectation.fulfill()
                }
            }, receiveValue: { (response: ApiResult<MockCharacter>) in
                XCTFail("Unexpected response \(response.success)")
            })
        
        // Complete the expectation
        wait(for: [expectation], timeout: 1)
    }
}

