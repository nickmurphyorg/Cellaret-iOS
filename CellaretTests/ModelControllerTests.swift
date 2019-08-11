//
//  ModelControllerTests.swift
//  CellaretTests
//
//  Created by Nick Murphy on 10/13/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import XCTest
@testable import Cellaret

class ModelControllerTests: XCTestCase {
    let testDrinkName = "Test Drink"
    let testDrinkCategory = 1
    
    var testDrink: Drink!
    var testDrinks: [Drink]!

    override func setUp() {
        let drink = Drink.init(drinkId: nil, imageId: nil, image: nil, name: testDrinkName, favorite: false, category: testDrinkCategory, alcoholVolume: 0.0)
        
        testDrinks = ModelController.shared.returnDrinksIn(category: 0)
        testDrink = ModelController.shared.saveNewDrink(drink)
        
        testDrinks.append(testDrink)
    }

    override func tearDown() {
        _ = ModelController.shared.deleteDrink(testDrinks.count - 1, testDrinks)
        
        testDrinks = nil
        testDrink = nil
    }
    
    func testReturnDrinksIn() {
        let returnedDrinksArray = ModelController.shared.returnDrinksIn(category: testDrinkCategory)
        
        for returnedDrink in returnedDrinksArray {
            XCTAssertEqual(returnedDrink.category, 1)
        }
    }

    func testSaveNewDrink() {
        let secondTestDrink = Drink.init(drinkId: nil, imageId: nil, image: nil, name: "Test 2", favorite: true, category: 2, alcoholVolume: 0.0)
        let savedDrink = ModelController.shared.saveNewDrink(secondTestDrink)
        
        testDrinks.append(savedDrink)
        
        testDrinks = ModelController.shared.deleteDrink(testDrinks.count - 1, testDrinks)
        
        XCTAssertTrue(savedDrink.drinkId != nil)
    }
    
    func testSaveEditedDrink() {
        testDrink.favorite = true
        
        ModelController.shared.saveEdited(testDrink)
        
        let categoryTwoDrinks = ModelController.shared.returnDrinksIn(category: 1)
        
        for drink in categoryTwoDrinks {
            if drink == testDrink {
                XCTAssertTrue(drink.favorite)
            }
        }
    }
    
    func testDeleteDrink() {
        _ = ModelController.shared.deleteDrink(testDrinks.count - 1, testDrinks)
        let updatedTestDrinks = ModelController.shared.returnDrinksIn(category: 0)
        
        XCTAssertTrue(updatedTestDrinks.count < testDrinks.count)
    }
}
