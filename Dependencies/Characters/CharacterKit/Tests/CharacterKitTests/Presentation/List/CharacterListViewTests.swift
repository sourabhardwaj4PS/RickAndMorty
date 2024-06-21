//
//  CharacterListViewTests.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import CharacterKit

class CharacterListViewTests: XCTestCase {
    
    var path: URL!

    override func setUpWithError() throws {
        MockContainer.setupMockDependencies()
    }
    
    override func tearDownWithError() throws {
        path = nil
    }
    
    func testCharacterRowView_shouldShowCharacterRowView() {
        guard var character = try? JSONDecoder().decode(CharacterImpl.self, from: MockData.character) else {
            return
        }
        
        // set image from resources
        path = getImageFromBundle(resource: "morty", withExtension: "jpg")
        character.image = path.absoluteString
        
        let characterVM = CharacterViewModelImpl(character: character)
        let rowView = CharacterRowView(viewModel: characterVM)
        
        rowView.toVC.performSnapshotTest(named: "CharacterRowView", testName: "shouldShowCharacterRowView")
    }
    
    func testCharactersListView_shouldShowCharactersListView() {
        guard let characters = try? JSONDecoder().decode(CharactersImpl.self, from: MockData.allCharacters) else {
            return
        }
        path = getImageFromBundle(resource: "rick", withExtension: "jpg")

        let results = characters.results
        
        let charactersVM = CharactersViewModelImpl()
        charactersVM.characters = results.map({ character in
            var character = character
            character.image = path.absoluteString
            return CharacterViewModelImpl(character: character)
        })

        let listView = CharactersListView(viewModel: charactersVM)
        listView.toVC.performSnapshotTest(named: "CharactersListView", testName: "shouldShowCharactersListView")
    }
}



extension SwiftUI.View {
    var toVC: UIViewController {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = UIScreen.main.bounds
        return hostingController
    }
}

extension UIViewController {
    func performSnapshotTest(named name: String,
                             testName: String = "Snapshot") {
        assertSnapshot(matching: self,
                       as: .image(precision: 0.9),
                       named: name,
                       testName: testName)
    }
}

extension XCTestCase {
    
    func getImageFromBundle(resource: String, withExtension: String) -> URL {
        // Access the module bundle
        let bundle = Bundle.module
        
        // Retrieve the URL for the resource
        guard let path = bundle.url(forResource: resource, withExtension: withExtension) else {
            fatalError("Resource not found: \(resource).\(withExtension)")
        }
        return path
    }
}
