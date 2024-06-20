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
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testCharacterRowView_shouldShowCharacterRowView() {
        let rowView = Text("characterRowView")
        
        rowView.toVC.performSnapshotTest(named: "CharacterRowView", testName: "shouldShowCharacterRowView")
    }
    
    func testCharactersListView_shouldShowCharactersListView() {
        let testView = Text("Test View")
        
        testView.toVC.performSnapshotTest(named: "CharactersListView", testName: "shouldShowCharactersListView")
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
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.url(forResource: resource, withExtension: withExtension) else {
            return URL(string: "")!
        }
        
        return path
    }
}
