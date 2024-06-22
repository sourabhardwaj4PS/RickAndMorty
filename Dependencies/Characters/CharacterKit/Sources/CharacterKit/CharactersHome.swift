//
//  CharactersHome.swift
//
//
//  Created by Sourabh Bhardwaj on 21/06/24.
//

import Foundation
import SwiftUI
import CoreKit
import Kingfisher

public struct CharactersHome: View {
    
    private var config: CharactersConfiguration
    private let challengeResponder = ImageAuthenticationChallengeResponder()
    
    public var body: some View {
        CharactersListView(viewModel: CharactersViewModelImpl())
    }
    
    public init(config: CharactersConfiguration) {
        self.config = config
        
        // make the config accessible globally
        CharacterManager.shared.configuration = config
        
        // register dependencies
        CharacterContainer.setupDependencies()
        
        // set custom challenge responder to thirdparty image downloader
        ImageDownloader.default.authenticationChallengeResponder = challengeResponder
    }
}

#Preview {
    CharactersListView(viewModel: CharactersViewModelImpl())
}
