//
//  ImageControllerTests.swift
//  CellaretTests
//
//  Created by Nick Murphy on 9/2/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import XCTest
@testable import Cellaret

class ImageControllerTests: XCTestCase {

    // Todo: Include all class methods in here...
    
    let testImageURL = "https://nickmurphy.org/wp-content/uploads/2019/04/ListAid-Icon.jpg"
    
    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func testDownloadImage() {
        ImageController.shared.downloadImage(testImageURL, completion: { (testImage) in
            XCTAssertTrue(testImage != nil)
        })
    }

}
