//
//  CharactersApp.swift
//  Characters
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import SwiftUI
import CharacterKit

@main
struct CharactersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        CharacterContainer.setupDependencies()
    }
}
