//
//  CharacterConfiguration.swift
//
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation
import CoreKit

public struct CharactersConfigurationImpl: CharactersConfiguration {
    public var baseUrl = URL(string: "https://rickandmortyapi.com/api").value
    public var analyticsUrl = URL(string: "https://analytics.com/api").value
    
    public var charactersPath: String = "/character"
    
    public init() { }
    
    public var description: String {
           """
           Characters Configuration:
           - Base URL: \(baseUrl)
           - Path: \(charactersPath)
           - Analytics URL: \(analyticsUrl)
           """
    }
}

class CharacterManager {
    static let shared = CharacterManager()

    private init() {}

    var configuration: CharactersConfiguration = CharactersConfigurationImpl() {
        didSet {
            DLog("\(configuration.description)")
        }
    }
}
