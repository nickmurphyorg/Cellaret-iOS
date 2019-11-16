//
//  ProductAPIControllerTests.swift
//  CellaretTests
//
//  Created by Nick Murphy on 8/18/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import XCTest
@testable import Cellaret

class ProductAPIControllerTests: XCTestCase {
    
    let testUPC = "080480280024" // Grey Goose Vodka

    override func setUp() {}

    override func tearDown() {}

    func testGetProduct() {
        ProductAPIController.shared.getProduct(UPC: testUPC, completion: {[weak self] (testProduct) in
            let testProduct: DrinkData? = testProduct
            
            XCTAssertTrue(testProduct != nil && testProduct?.item_attributes.upc == self?.testUPC)
        })
    }

}
