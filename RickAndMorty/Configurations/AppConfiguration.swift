//
//  AppConfiguration.swift
//  RickAndMorty
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation
import CoreKit

public struct AppConfiguration: BaseConfiguration {
    
    public let baseUrl = Configuration.baseURL
    public let analyticsUrl = Configuration.analyticsURL
        
    public var description: String {
           """
           Configuration:
           - Base URL: \(baseUrl)
           - Analytics URL: \(analyticsUrl)
           - Characters Path: \(charactersPath)
           - Episodes Path: \(episodesPath)
           """
    }
}

extension AppConfiguration: CharactersConfiguration {
    
    public var charactersPath: String {
        get {
            return Configuration.charactersPath
        }
    }
}

extension AppConfiguration: EpisodesConfiguration {
    
    public var episodesPath: String {
        get {
            return Configuration.episodesPath
        }
    }
    
}
