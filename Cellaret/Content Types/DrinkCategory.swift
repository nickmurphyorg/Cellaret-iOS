//
//  DrinkCategory.swift
//  Cellaret
//
//  Created by Nick Murphy on 12/31/19.
//  Copyright © 2019 Nick Murphy. All rights reserved.
//

import Foundation

class DrinkDetail: DrinkContent {
    let type: DrinkContentType
    let title: String
    let content: String
    
    init(_ title: String, _ content: String) {
        self.type = .detail
        self.title = title
        self.content = content
    }
}
