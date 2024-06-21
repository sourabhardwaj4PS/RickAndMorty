//
//  AppConfiguration.swift
//
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation

public protocol BaseConfiguration: CustomStringConvertible {
    
    /// For network calls
    var baseURL: String { get }
    
    /// To track analytics
    var analyticsURL: String { get }
    
}

public protocol CharactersConfiguration: BaseConfiguration {
    
    /// Path for characters
    var charactersPath: String { get }
    
    // Add other configuration properties here
}

public protocol EpisodesConfiguration: BaseConfiguration {
    
    /// Path for episodes
    var episodesPath: String { get }
    
    // Add other configuration properties here
}
