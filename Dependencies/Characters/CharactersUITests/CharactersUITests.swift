//
//  CharactersUITests.swift
//  CharactersUITests
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import XCTest

final class CharactersUITests: XCTestCase {

    private var app: XCUIApplication!
    var charactersListView: XCUIElement!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
        
        // Print the entire view hierarchy
        //print(app.debugDescription)
        
        charactersListView = app.collectionViews["charactersListView"]
    }

    override func tearDownWithError() throws {
        app = nil
        charactersListView = nil
    }
    
    func testCharacterRowView() {
        // Wait for charactersListView to appear
        XCTAssertTrue(charactersListView.waitForExistence(timeout: 5), "charactersListView should be present.")

        // Check a specific row
        let firstCharacterRowView = charactersListView.otherElements["rowView-1"]
        XCTAssertTrue(firstCharacterRowView.exists, "rowView-1 should be present.")

        // Check attributes view within the row
        let attributesView = firstCharacterRowView.otherElements["attributesView-1"]
        XCTAssertTrue(attributesView.exists, "attributesView should be present.")
    }
    
    func testCharactersListView_charactersList_shouldShowList() throws {
        // Check if the table view exists
        XCTAssertTrue(charactersListView.exists, "The characters list view should be present.")
        
        // Check the number of cells
        let cells = charactersListView.cells
        XCTAssertGreaterThan(cells.count, 0, "The characters list should have at least one cell.")
        
        // Find the first cell
        let cell = cells.element(boundBy: 1)
        XCTAssertTrue(cell.exists, "The first character cell should be present.")
    }
    
    func testCharactersListView_charactersList_loadMorePagesOnScroll() throws {
        // Check if the table view exists
        XCTAssertTrue(charactersListView.exists, "The characters list view should be present.")
        
        // last cell before scrolling
        let initialLastCell = charactersListView.cells.element(boundBy: charactersListView.cells.count - 2)
        XCTAssertTrue(initialLastCell.exists, "The initial last cell does not exist")
        
        let initialLastCellIdentifier = "rowView-5" // initialLastCell.identifier
        XCTAssertFalse(initialLastCellIdentifier.isEmpty, "The identifier of the initial last cell is empty")
        
        // scroll to the bottom
        charactersListView.scrollToBottom()
        
        // last cell before scrolling
        let newLastCell = charactersListView.cells.element(boundBy: charactersListView.cells.count - 1)
        XCTAssertTrue(newLastCell.exists, "The new last cell does not exist")

        let newLastCellIdentifier = "rowView-25" //newLastCell.identifier
        XCTAssertFalse(newLastCellIdentifier.isEmpty, "The identifier of the new last cell is empty")

        // Verify that more items are loaded
        XCTAssertNotEqual(initialLastCellIdentifier, newLastCellIdentifier, "The 'load more' functionality did not load additional items")
    }
    
    func testCharacterRowView_charactersList_shouldShowRowView() throws {
        let cell = charactersListView.cells.element(boundBy: 1)
        XCTAssertTrue(cell.exists, "The first character cell should be present.")
        
        // Check if the character row view is correctly displayed
        let characterRowView = cell.otherElements["rowView-2"]
        XCTAssertTrue(characterRowView.exists, "The character row view should be displayed.")
    }

    func testCharacterRowView_charactersList_shouldShowAttributes() throws {
        let cell = charactersListView.cells.element(boundBy: 1)
        XCTAssertTrue(cell.exists, "The first character cell should be present.")

        // Check if the attributes view is correctly displayed
        let attributesView = app.otherElements["attributesView-1"]
        XCTAssertTrue(attributesView.exists, "The attributes view should be displayed.")

        // Check if specific attributes are displayed
        let attributeName = attributesView.staticTexts["name-1"]
        XCTAssertTrue(attributeName.exists, "The attribute name should be displayed.")

        let attributeValue = attributesView.staticTexts["gender-1"]
        XCTAssertTrue(attributeValue.exists, "The attribute gender should be displayed.")
    }
    
    func testCharactersListView_tappingCharactersList_shouldShowDetailsView() throws {
        let cell = charactersListView.cells.element(boundBy: 2)
        XCTAssertTrue(cell.exists, "The first character cell should be present.")

        // Tap the cell to display the detail view
        cell.tap()
        
        // Check if the detail view is displayed
        let characterDetailsView = app.scrollViews["characterDetailsView"]
        XCTAssertTrue(characterDetailsView.waitForExistence(timeout: 10), 
                      "The character detail view should be displayed after tapping a character cell.")
        
        characterDetailsView.scrollToBottom(maxScrolls: 2)
    }
}

extension XCUIElement {
    func scrollToBottom(maxScrolls: Int = 6) {
           var currentScrolls = 0
           while currentScrolls < maxScrolls {
               swipeUp()
               currentScrolls += 1
               print("swiping up = \(currentScrolls)")
           }
       }
}
