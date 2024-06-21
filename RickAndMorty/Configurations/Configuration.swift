//
//  Configuration.swift
//  RickAndMorty
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation

final class Configuration {
    
    static var baseURL: URL {
        guard let baseURL = Bundle.main.baseUrl else {
            fatalError("BASE_URL not set. Check Configurations and Info.plist")
        }
        return baseURL
    }

    static var analyticsURL: URL {
        guard let analyticsURL = Bundle.main.analyticsUrl else {
            fatalError("ANALYTICS_URL not set. Check Configurations and Info.plist")
        }
        return analyticsURL
    }
    
    static var charactersPath: String {
        guard let charactersPath = Bundle.main.charactersPath else {
            fatalError("CHARACTERS_PATH not set. Check Configurations and Info.plist")
        }
        return charactersPath
    }
    
    static var episodesPath: String {
        guard let episodesPath = Bundle.main.episodesPath else {
            fatalError("EPISODES_PATH not set. Check Configurations and Info.plist")
        }
        return episodesPath
    }
}

extension Bundle {
    var baseUrl: URL? {
        guard let baseUrlString = self.infoDictionary?["BASE_URL"] as? String,
              let url = URL(string: "https://" + baseUrlString) else {
            return nil
        }
        return url
    }
    
    var analyticsUrl: URL? {
        guard let analyticsUrlString = self.infoDictionary?["ANALYTICS_URL"] as? String,
              let url = URL(string: "https://" + analyticsUrlString) else {
            return nil
        }
        return url
    }
    
    var charactersPath: String? {
        guard let charactersPath = self.infoDictionary?["CHARACTERS_PATH"] as? String else {
            return nil
        }
        return charactersPath
    }
    
    var episodesPath: String? {
        guard let episodesPath = self.infoDictionary?["EPISODES_PATH"] as? String else {
            return nil
        }
        return episodesPath
    }
}
