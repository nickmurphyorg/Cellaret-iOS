//
//  Drink.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/8/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Drink {
    typealias percent = Double
    
    var image: UIImage?
    var name: String
    var favorite: Bool
    var category: Int
    var alcoholVolume: percent
}

extension Drink{
    init(drinkEntity: NSManagedObject) {
        self.image = nil
        self.name = drinkEntity.value(forKey: "name") as! String
        self.favorite = drinkEntity.value(forKey: "favorite") as! Bool
        self.category = drinkEntity.value(forKey: "category") as! Int
        self.alcoholVolume = drinkEntity.value(forKey: "alcoholVolume") as! Double
    }
}
