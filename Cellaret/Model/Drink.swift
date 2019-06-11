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
    
    var imageId: String?
    var image: UIImage?
    var name: String
    var favorite: Bool
    var category: Int
    var alcoholVolume: percent
}

extension Drink{
    init(drinkEntity: NSManagedObject) {
        if let imageId = drinkEntity.value(forKey: modelKey.imageId.rawValue) {
            self.image = ImageController.shared.fetchImage(imageID: imageId as! String)
        } else {
            self.image = nil
        }
        self.imageId = drinkEntity.value(forKey: modelKey.imageId.rawValue) as? String
        self.name = drinkEntity.value(forKey: modelKey.name.rawValue) as! String
        self.favorite = drinkEntity.value(forKey: modelKey.favorite.rawValue) as! Bool
        self.category = drinkEntity.value(forKey: modelKey.category.rawValue) as! Int
        self.alcoholVolume = drinkEntity.value(forKey: modelKey.alcoholVolume.rawValue) as! Double
    }
}
