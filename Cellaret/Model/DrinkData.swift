//
//  DrinkData.swift
//  Cellaret
//
//  Created by Nick Murphy on 9/15/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import Foundation

struct DrinkData: Codable {
    struct Values: Codable {
        var title: String
        var image: String
        var upc: String
        var size: String
    }
    
    let item_attributes: Values
}
