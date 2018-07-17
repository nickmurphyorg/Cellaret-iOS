//
//  Drink.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/8/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation

struct Drink {
    typealias percent = Int
    
    var name: String
    var favorite: Bool
    var category: Int
    var alcoholVolume: percent?
}
