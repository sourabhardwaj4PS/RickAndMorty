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
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testCharacterDetailsView_shouldShowCharacterDetailsView() {
        let characterDetailsView = Text("characterDetailsView")
        
        characterDetailsView.toVC.performSnapshotTest(named: "CharacterDetailsView", testName: "shouldShowCharacterDetailsView")
    }
}
