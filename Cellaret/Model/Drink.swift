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

struct Drink: Equatable {
    typealias percent = Double
    
    var drinkId: NSManagedObjectID?
    var imageId: String?
    var image: UIImage?
    var name: String
    var favorite: Bool
    var category: Int
    var alcoholVolume: percent
}

extension Drink{
    init(drinkEntity: NSManagedObject) {
        let drinkObject = drinkEntity as! DrinkEntity
        
        if let imageId = drinkObject.imageId {
            self.image = ImageController.shared.fetchImage(imageID: imageId)
        }
        
        self.drinkId = drinkObject.objectID
        self.imageId = drinkObject.imageId
        self.name = drinkObject.name ?? ""
        self.favorite = drinkObject.favorite
        self.category = Int(drinkObject.category)
        self.alcoholVolume = drinkObject.alcoholVolume
    }
}
