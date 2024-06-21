//
//  CharactersHome.swift
//
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation
import SwiftUI
import CoreKit

public struct CharactersHome: View {
    
    private var config: CharactersConfiguration
    
    public var body: some View {
        CharactersListView(viewModel: CharactersViewModelImpl())
    }
    
    public init(config: CharactersConfiguration) {
        self.config = config
        
        // make the config accessible globally
        CharacterManager.shared.configuration = config
        
        // register dependencies
        CharacterContainer.setupDependencies()
    }
}

#Preview {
    CharactersListView(viewModel: CharactersViewModelImpl())
}
