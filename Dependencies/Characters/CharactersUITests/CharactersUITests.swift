//
//  CharactersUITests.swift
//  CharactersUITests
//
//  Created by Sourabh Bhardwaj on 13/06/24.
//

import XCTest

final class CharactersUITests: XCTestCase {

    private var app: XCUIApplication!
    var tableView: XCUIElement!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
        
        // Print the entire view hierarchy
        print(app.debugDescription)
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    override func tearDownWithError() throws {
        app = nil
        tableView = nil
    }
    
    func testCharacterRowView() {

        // Wait for charactersListView to appear
        let charactersListView = app.collectionViews["charactersListView"]
        XCTAssertTrue(charactersListView.waitForExistence(timeout: 5), "charactersListView should be present.")

        // Check a specific row
        let firstCharacterRowView = charactersListView.otherElements["rowView-1"]
        XCTAssertTrue(firstCharacterRowView.exists, "rowView-1 should be present.")

        // Check attributes view within the row
        let attributesView = firstCharacterRowView.otherElements["attributesView"]
        XCTAssertTrue(attributesView.exists, "attributesView should be present.")
    }
    
    func testCharactersListView_charactersList_shouldShowList() throws {
        // Check if the table view exists
        tableView = app.collectionViews["charactersListView"]
        
        XCTAssertTrue(tableView.exists, "The characters list view should be present.")
        
        // Check the number of cells
        let cells = tableView.cells
        XCTAssertGreaterThan(cells.count, 0, "The characters list should have at least one cell.")
        
        // Find the first cell
        let firstCell = cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first character cell should be present.")
    }
    
    func testCharactersListView_charactersList_shouldLoadMorePagesOnScroll() throws {
        let app = XCUIApplication()
        let tableView = app.collectionViews["charactersListView"]

        // Check if the table view exists
        XCTAssertTrue(tableView.exists, "The characters list view should be present.")

        // scroll to bottom
        
        // Check the number of cells
        let cells = tableView.cells
        XCTAssertGreaterThan(cells.count, 0, "The characters list should have at least one cell.")

        // Tap the first cell
        let firstCell = cells.element(boundBy: 0)
        
        XCTAssertTrue(firstCell.exists, "The first character cell should be present.")
        firstCell.tap()
    }

    
    func testCharacterRowView_charactersList_shouldShowRowView() throws {
        let tableView = app.collectionViews["charactersListView"]
        let firstCell = tableView.cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.exists, "The first character cell should be present.")
        
        print(firstCell.debugDescription)

        // Check if the character row view is correctly displayed
        let characterRowView = firstCell.otherElements["CharacterListView.RowView-1"]
        XCTAssertTrue(characterRowView.exists, "The character row view should be displayed.")
    }

    func testCharacterRowView_charactersList_shouldShowAttributes() throws {
        let app = XCUIApplication()
        let tableView = app.collectionViews["charactersListView"]
        let firstCell = tableView.cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.exists, "The first character cell should be present.")

        // Check if the attributes view is correctly displayed
        let attributesView = app.otherElements["attributesView"]
        XCTAssertTrue(attributesView.exists, "The attributes view should be displayed.")

        // Check if specific attributes are displayed
        let attributeName = attributesView.staticTexts["name"]
        XCTAssertTrue(attributeName.exists, "The attribute name should be displayed.")

        let attributeValue = attributesView.staticTexts["gender"]
        XCTAssertTrue(attributeValue.exists, "The attribute gender should be displayed.")
    }
    
    func testCharactersListView_tappingCharactersList_shouldShowDetailsView() throws {
        let app = XCUIApplication()
        let tableView = app.collectionViews["charactersListView"]
        let firstCell = tableView.cells.element(boundBy: 0)

        XCTAssertTrue(firstCell.exists, "The first character cell should be present.")

        // Tap the first cell to display the detail view
        firstCell.tap()

        // Check if the detail view is displayed
        let detailView = app.otherElements["characterDetailView"]
        XCTAssertTrue(detailView.exists, "The character detail view should be displayed after tapping a character cell.")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
