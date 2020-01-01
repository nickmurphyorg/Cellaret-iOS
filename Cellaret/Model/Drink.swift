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
    var alcoholVolume: percent?
    var upc: String?
}

// MARK: - Initialize Empty Drink
extension Drink {
    init() {
        self.drinkId = nil
        self.imageId = nil
        self.image = nil
        self.name = ""
        self.favorite = false
        self.category = 0
        self.alcoholVolume = nil
        self.upc = nil
    }
}

// MARK: - Initialize From Core Data Object
extension Drink {
    init(drinkEntity: NSManagedObject) {
        let drinkObject = drinkEntity as! DrinkEntity
        
        if let imageId = drinkObject.imageId {
            self.image = ImageController.shared.fetchImage(imageID: imageId, imageSize.small)
        }
        
        self.drinkId = drinkObject.objectID
        self.imageId = drinkObject.imageId
        self.name = drinkObject.name ?? ""
        self.favorite = drinkObject.favorite
        self.category = Int(drinkObject.category)
        self.alcoholVolume = drinkObject.alcoholVolume as? Drink.percent
        self.upc = drinkObject.upc
    }
}

// MARK: - Convert To Content Array
extension Drink {
    func content() -> [DrinkContent] {
        var data = [DrinkContent]()
        
        let category = Menu.shared.selectionName(selection: self.category)
        
        data.append(DrinkImage(self.image))
        data.append(DrinkTitle(self.name, self.favorite))
        data.append(DrinkDetail("Category", category))
        
        if let alcoholVolume = self.alcoholVolume {
            data.append(DrinkDetail("Alcohol / Volume", String(alcoholVolume) + "%"))
        }
        
        if let upc = self.upc {
            data.append(DrinkDetail("UPC", upc))
        }
        
        return data
    }
}
