//
//  CharactersEndpoint.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import NetworkKit

public enum CharactersEndpoint: ApiEndpoint {
    
    case characters(page: Int)
    case characterDetails(characterId: Int)

    public var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }

    public var path: String {
        switch self {
        case .characters:
            return "/character/"
        case .characterDetails(characterId: let characterId):
            return "/character/\(characterId)"
        }
    }

    public var method: HttpMethod {
        switch self {
        case .characters:
            return .get
        case .characterDetails:
            return .get
        }
    }

    public var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return headers
    }

    public var body: Data? {
        return nil
    }
    
    public var queryItems: [URLQueryItem]? {
        switch self {
        case .characters(page: let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .characterDetails:
            return nil

        }
    }
}
