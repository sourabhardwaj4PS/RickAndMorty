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
    func test_CreateRequest() {
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
    
    func test_CreateRequest_WithHeaders() {
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
    func test_ExecuteRequest_ShouldReturnSuccessResponse() async throws {
        let expectation = XCTestExpectation(description: "The executeRequest method should return successful response.")
        
        // Given
        let expectedData =
                """
                {
                    "key": "value"
                }
                """.data(using: .utf8)!
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com/api/test")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
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
                }, receiveValue: { (result: [String: String]) in
                    // Then
                    XCTAssertEqual(result["key"], "value")
                    expectation.fulfill()
                })
            
            // Complete the expectation
            await fulfillment(of: [expectation], timeout: 1.0)

        }
        catch let exception {
            print("Exception in test_ExecuteRequest_ShouldReturnSuccessResponse = \(exception)")
        }
    }
    
    func test_ExecuteRequest_ShouldReturnFailureResponse() throws {
        let expectation = XCTestExpectation(description: "The executeRequest method should return error.")

        // Given
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        // When
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
            
            _ = try apiClient?.execute(urlRequest: request)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Then
                        XCTAssertTrue(error is ApiError, "Error is not of type ApiError")
                        //XCTAssertEqual(error as! ApiError, ApiError.customError(statusCode: 404))
                        expectation.fulfill()
                    }
                    else {
                        XCTFail("Expected failure, got success")
                    }
                }, receiveValue: { (result: [String: String]) in
                    XCTFail("Expected failure, got success = \(result)")
                })
            
            // Complete the expectation
            wait(for: [expectation], timeout: 1)
        }
        catch let exception {
            print("Exception in test_ExecuteRequest_ShouldReturnFailureResponse = \(exception)")
        }
    }
    
    func test_ExecuteRequest_ShouldReturnDecodingFailedResponse() throws {
        let expectation = XCTestExpectation(description: "The executeRequest method should Decoding Failed error.")
        
        // Given
        let invalidJSONData = "Invalid JSON".data(using: .utf8)!

        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJSONData)
        }

        // When
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
            
            _ = try apiClient?.execute(urlRequest: request)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Then
                        XCTAssertNotNil(error)
                        XCTAssertEqual(error as! ApiError, ApiError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "The given data was not valid JSON."))))
                        expectation.fulfill()
                    }
                    else {
                        XCTFail("Expected failure, got success")
                    }
                }, receiveValue: { (result: [String: String]) in
                    XCTFail("Expected failure, got success = \(result)")
                })
            
            // Complete the expectation
            wait(for: [expectation], timeout: 1)
        }
        catch let exception {
            print("Exception in test_ExecuteRequest_ShouldReturnDecodingFailedResponse = \(exception)")
        }
    }
    
    func test_ExecuteRequest_ShouldReturnRequestFailedResponse() throws {
        let expectation = XCTestExpectation(description: "The executeRequest method should Request Failed error.")

        // Given
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.requestFailed = true
        
        // When
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
            
            _ = try apiClient?.execute(urlRequest: request)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Then
                        XCTAssertNotNil(error)
                        XCTAssertEqual(error as? ApiError, ApiError.requestFailed)
                        expectation.fulfill()
                    }
                    else {
                        XCTFail("Expected failure, got success")
                    }
                }, receiveValue: { (result: [String: String]) in
                    XCTFail("Expected failure, got success = \(result)")
                })
            
            // Complete the expectation
            wait(for: [expectation], timeout: 1)
        }
        catch let exception {
            print("Exception in test_ExecuteRequest_ShouldReturnRequestFailedResponse = \(exception)")
        }
    }
    
    func test_ExecuteRequest_ShouldReturnUnknownErrorResponse() throws {
        let expectation = XCTestExpectation(description: "The executeRequest method should Request Failed error.")

        // Given
        let expectedError = ApiError.unknownError(URLError(.badServerResponse))

        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            throw expectedError
        }
                
        // When
        do {
            guard let request = try apiClient?.createRequest(.characters(page: 1)) else { throw ApiError.invalidRequest }
            
            _ = try apiClient?.execute(urlRequest: request)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Then
                        XCTAssertNotNil(error)
                        //XCTAssertEqual(error as? ApiError, expectedError)
                        expectation.fulfill()
                    }
                    else {
                        XCTFail("Expected failure, got success")
                    }
                }, receiveValue: { (result: [String: String]) in
                    XCTFail("Expected failure, got success = \(result)")
                })
            
            // Complete the expectation
            wait(for: [expectation], timeout: 1)
        }
        catch let exception {
            print("Exception in test_ExecuteRequest_ShouldReturnUnknownErrorResponse = \(exception)")
        }
    }
}

