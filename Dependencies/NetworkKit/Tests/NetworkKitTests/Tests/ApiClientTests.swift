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
    private var apiClient: SessionApiClient<MockEndpoint>?

    // MARK: - Setup and TearDown
    override func setUp() {
        super.setUp()
        apiClient = SessionApiClient<MockEndpoint>(session: MockURLSession())
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    // MARK: - Request Validation
    func testCreateRequest() {
        // Given
        let endpoint = MockEndpoint.characters(page: 1)
        
        do {
            // When
            let request = try apiClient?.createRequest(endpoint)
            
            // Then
            XCTAssertNotNil(request)
            XCTAssertEqual(request?.url?.absoluteString, "https://mocked.com/api/character/?page=1")
            XCTAssertEqual(request?.httpMethod, "GET")
        }
        catch let exception {
            print("Exeption in testCreateRequest = \(exception)")
        }
    }
    
    /*func testCreateRequest_ThrowsInvalidComponentsError() {
        // Given
        let invalidURL = URL(string: "invalid url")! // Invalid URL
        let endpoint = MockEndpoint(baseURL: invalidURL, path: "", method: .get, queryItems: nil, body: nil, headers: nil)
        
        // When & Then
        XCTAssertThrowsError(try createRequest(endpoint)) { error in
            XCTAssertEqual(error as? RequestError, RequestError.invalidComponents)
        }
    }

    func testCreateRequest_ThrowsInvalidURLError() {
        // Given
        let validURL = URL(string: "https://example.com")! // Valid base URL
        let endpoint = MockEndpoint(baseURL: validURL, path: "invalid path", method: .get, queryItems: nil, body: nil, headers: nil)
        
        // When & Then
        XCTAssertThrowsError(try createRequest(endpoint)) { error in
            XCTAssertEqual(error as? RequestError, RequestError.invalidURL)
        }
    }*/
    
    func testCreateRequest_WithHeaders() {
        do {
            // validate request creation
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else {
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
        catch let exception {
            print("Exeption in testCreateRequest_WithHeaders = \(exception)")
        }
    }
    
    
    // MARK: - Executing Request
    func testRequestSuccess() async throws {
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
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }

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
        catch let exception {
            print("Exeption in testRequestSuccess = \(exception)")
        }
    }
    
    func testRequestFailureCustomError() throws {
        // Given
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 422, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        let expectation = XCTestExpectation(description: "Request should fail")

        // When
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
            
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
        catch let exception {
            print("Exeption in testRequestFailureCustomError = \(exception)")
        }
    }
    
    func testRequestFailureDecodingFailed() throws {
        // Given
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.decodingFailed = true
        
        let expectation = XCTestExpectation(description: "Request failed!")

        // When
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
            
            _ = try apiClient?.execute(urlRequest: request)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected success")
                    case let .failure(error):
                        // Then
                        XCTAssertNotNil(error)
                        //XCTAssertEqual(error as? ApiError, ApiError.decodingFailed)
                        expectation.fulfill()
                    }
                }, receiveValue: { (response: ApiResult<MockCharacter>) in
                    XCTFail("Unexpected response \(response.success)")
                })
            
            // Complete the expectation
            wait(for: [expectation], timeout: 1)
        }
        catch let exception {
            print("Exeption in testRequestFailureDecodingFailed = \(exception)")
        }
    }
    
    func testRequestFailureRequestFailed() throws {
        // Given
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.requestFailed = true

        let expectation = XCTestExpectation(description: "Request failed!")
        
        // When
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
            
            _ = try apiClient?.execute(urlRequest: request)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected success")
                    case let .failure(error):
                        // Then
                        XCTAssertNotNil(error)
                        //XCTAssertEqual(error as! ApiError, ApiError.requestFailed)
                        expectation.fulfill()
                    }
                }, receiveValue: { (response: ApiResult<MockCharacter>) in
                    XCTFail("Unexpected response \(response.success)")
                })
            
            // Complete the expectation
            wait(for: [expectation], timeout: 1)
        }
        catch let exception {
            print("Exeption in testRequestFailureDecodingFailed = \(exception)")
        }
    }
}

