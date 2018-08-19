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
    
    var imageId: String?
    var image: UIImage?
    var name: String
    var favorite: Bool
    var category: Int
    var alcoholVolume: percent
}

extension Drink{
    init(drinkEntity: NSManagedObject) {
        if let imageId = drinkEntity.value(forKey: "imageId") {
            print("\(drinkEntity.value(forKey: "name") as! String) has an image ID: \(imageId)")
            self.image = ImageController.shared.fetchImage(imageID: imageId as! String)
        } else {
            self.image = nil
        }
        self.imageId = drinkEntity.value(forKey: "imageId") as? String
        self.name = drinkEntity.value(forKey: "name") as! String
        self.favorite = drinkEntity.value(forKey: "favorite") as! Bool
        self.category = drinkEntity.value(forKey: "category") as! Int
        self.alcoholVolume = drinkEntity.value(forKey: "alcoholVolume") as! Double
    }
}
