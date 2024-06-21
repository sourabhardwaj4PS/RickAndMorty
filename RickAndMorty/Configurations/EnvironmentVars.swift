//
//  EnvironmentVars.swift
//  RickAndMorty
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation

final class EnvironmentVars {
    
    static var baseURL: String {
        guard let baseURL = ProcessInfo.processInfo.environment["BASE_URL"] else {
            fatalError("BASE_URL not set in environment")
        }
        return baseURL
    }

    static var analyticsURL: String {
        guard let analyticsURL = ProcessInfo.processInfo.environment["ANALYTICS_URL"] else {
            fatalError("ANALYTICS_URL not set in environment")
        }
        return analyticsURL
    }
    
    static var charactersPath: String {
        guard let charactersPath = ProcessInfo.processInfo.environment["CHARACTERS_PATH"] else {
            fatalError("CHARACTERS_PATH not set in environment")
        }
        return charactersPath
    }
    
    static var episodesPath: String {
        guard let episodesPath = ProcessInfo.processInfo.environment["EPISODES_PATH"] else {
            fatalError("EPISODES_PATH not set in environment")
        }
        return episodesPath
    }
}
