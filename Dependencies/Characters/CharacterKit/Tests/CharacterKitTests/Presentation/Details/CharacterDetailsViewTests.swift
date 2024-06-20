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
        CharacterContainer.setupDependencies()
    }
    
    override func tearDownWithError() throws {
        path = nil
    }
    
    func testCharacterDetailsView_shouldShowCharacterDetailsView() {
        guard var character = try? JSONDecoder().decode(CharacterImpl.self, from: MockData.character) else {
            return
        }
        
        // set image from resources
        let path = getImageFromBundle(resource: "rick", withExtension: "jpg")
        character.image = path.absoluteString
        
        let characterDetailsVM = CharacterDetailsViewModelImpl(characterId: character.id)
        //characterDetailsVM.loadCharacterDetails(id: character.id)
        characterDetailsVM.character = character
        let detailsView = CharacterDetailsView(viewModel: characterDetailsVM)
        characterDetailsVM.finishedLoading = true
        
        detailsView.toVC.performSnapshotTest(named: "CharacterDetailsView", testName: "shouldShowCharacterDetailsView")
    }
}
