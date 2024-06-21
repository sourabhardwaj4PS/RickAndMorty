//
//  CharacterConfiguration.swift
//
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation
import CoreKit

public struct CharactersConfigurationImpl: CharactersConfiguration {
    public var baseURL = "https://rickandmortyapi.com/api"
    public var charactersPath: String = "/character"
    public var analyticsURL = "https://analytics.com/api"
    
    public init() { }
    
    public var description: String {
           """
           Chracters Configuration:
           - Base URL: \(baseURL)
           - Path: \(charactersPath)
           - Analytics URL: \(analyticsURL)
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
