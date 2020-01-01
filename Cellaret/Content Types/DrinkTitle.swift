//
//  DrinkTitle.swift
//  Cellaret
//
//  Created by Nick Murphy on 12/31/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import Foundation

class DrinkTitle: DrinkContent {
    let type: DrinkContentType
    let title: String
    let favorite: Bool
    
    init(_ title: String, _ favorite: Bool) {
        self.type = .title
        self.title = title
        self.favorite = favorite
    }
}
