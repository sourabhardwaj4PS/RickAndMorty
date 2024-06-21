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
        return URL(string: CharacterManager.shared.configuration.baseURL).value
    }

    public var path: String {
        switch self {
        case .characters:
            return CharacterManager.shared.configuration.charactersPath
        case .characterDetails(characterId: let characterId):
            return "/\(CharacterManager.shared.configuration.charactersPath)/\(characterId)"
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
