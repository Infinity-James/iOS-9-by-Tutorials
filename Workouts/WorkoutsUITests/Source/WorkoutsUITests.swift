//
//  WorkoutsUITests.swift
//  WorkoutsUITests
//
//  Created by James Valaitis on 20/02/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import XCTest

class WorkoutsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testRaysFullBodyWorkout() {
        let app = XCUIApplication()
        
        app.tables["Workouts Table"].staticTexts["Ray's Full Body Workout"].tap()
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        
        app.tables["Workout Detail Table"].buttons["Select & Workout"].tap()
        
        app.alerts["Woo hoo! You worked out!"].collectionViews.buttons["OK"].tap()
        app.navigationBars["Ray's Full Body Workout"].buttons["Workouts"].tap()
        
//        let app = XCUIApplication()
//        
//        let identifier = "Ray's Full Body Workout"
//        
//        let workoutQuery = app.tables.cells.containingType(.StaticText, identifier: identifier)
//        workoutQuery.element.tap()
//        
//        app.tables["Workout Detail Table"].swipeUp()
//        app.tables.buttons["Select & Workout"].tap()
//        app.alerts.buttons["OK"].tap()
//        
//        app.navigationBars.buttons["Workouts"].tap()
    }
}