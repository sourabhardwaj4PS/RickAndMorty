//
//  Environment.swift
//  RickAndMorty
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation
import CoreKit

public struct AppConfiguration: BaseConfiguration {
    
    public let baseURL = EnvironmentVars.baseURL
    public let analyticsURL = EnvironmentVars.analyticsURL
    
    public init() { }
    
    public var description: String {
           """
           Configuration:
           - Base URL: \(baseURL)
           - Analytics URL: \(analyticsURL)
           - Characters Path: \(charactersPath)
           - Episodes Path: \(episodesPath)
           """
    }
}

extension AppConfiguration: CharactersConfiguration {
    
    public var charactersPath: String {
        get {
            return EnvironmentVars.charactersPath
        }
    }
}

extension AppConfiguration: EpisodesConfiguration {
    
    public var episodesPath: String {
        get {
            return EnvironmentVars.episodesPath
        }
    }
    
}
