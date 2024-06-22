//
//  CharacterDetailsViewTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import CharacterKit

class CharacterDetailsViewTests: XCTestCase {
    
    var path: URL!

    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
    }
    
    override func tearDownWithError() throws {
        path = nil
    }
    
    func testCharacterDetailsView_shouldShowCharacterDetailsView() {
        // Given
        guard var character = try? JSONDecoder().decode(CharacterImpl.self, from: MockData.character) else {
            return
        }
        
        // set image from resources
        let path = getImageFromBundle(resource: "rick", withExtension: "jpg")
        character.image = path.absoluteString
        
        let characterDetailsVM = CharacterDetailsViewModelImpl(characterId: character.id)
        characterDetailsVM.character = character
        let detailsView = CharacterDetailsView(viewModel: characterDetailsVM)
        characterDetailsVM.finishedLoading = true
        
        // When & Then
        // perform snapshot test
        assertSnapshot(of: detailsView.toVC,
                       as: .image(precision: 0.9),
                       named: "shouldShowCharacterDetailsView",
                       testName: "CharacterDetailsView")
    }
}
