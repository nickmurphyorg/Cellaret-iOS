//
//  ModelController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/7/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ModelController {
    static let shared = ModelController()
    
    private let drinkEntityName = "DrinkEntity"
    
    private var managedContext: NSManagedObjectContext!
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func returnDrinksIn(category: Int) -> [Drink] {
        let drinkRequest = NSFetchRequest<NSManagedObject>(entityName: drinkEntityName)
        if category != 0 {
            drinkRequest.predicate = NSPredicate(format: "\(modelKey.category.rawValue) == %i", category)
        }
        
        var drinks = [Drink]()
        
        do {
            let returnedDrinks: [NSManagedObject] = try managedContext.fetch(drinkRequest)
            
            print("Coredata returned \(returnedDrinks.count) drinks.")
            
            for drink in returnedDrinks {
                let drinkObject = Drink.init(drinkEntity: drink)
                
                drinks.append(drinkObject)
            }
        } catch let error as NSError {
            print("Drinks could not be retrieved: \(error)\n \(error.userInfo).")
        }
        
        return drinks
    }
    
    func saveNewDrink(_ drink: Drink) -> Drink {
        let entity = NSEntityDescription.entity(forEntityName: drinkEntityName, in: managedContext)
        let drinkEntity = NSManagedObject(entity: entity!, insertInto: managedContext) as! DrinkEntity
        
        drinkEntity.imageId = drink.imageId
        drinkEntity.name = drink.name
        drinkEntity.favorite = drink.favorite
        drinkEntity.category = Int16(drink.category)
        drinkEntity.alcoholVolume = drink.alcoholVolume as NSNumber?
        drinkEntity.upc = drink.upc
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)\n \(error.userInfo)")
        }
        
        return Drink.init(drinkEntity: drinkEntity)
    }
    
    func saveEdited(_ drink: Drink) {
        guard drink.drinkId != nil else {
            let _ = saveNewDrink(drink)
            
            return
        }
        
        let drinkEntity = managedContext.object(with: drink.drinkId!) as! DrinkEntity
        
        if let savedImageId = drinkEntity.imageId {
            if savedImageId != drink.imageId {
                ImageController.shared.deleteImage(imageID: savedImageId)
            }
        }
        
        drinkEntity.imageId = drink.imageId
        drinkEntity.name = drink.name
        drinkEntity.favorite = drink.favorite
        drinkEntity.category = Int16(drink.category)
        drinkEntity.alcoholVolume = drink.alcoholVolume as NSNumber?
        drinkEntity.upc = drink.upc
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)\n \(error.userInfo)")
        }
    }
    
    func deleteDrink(_ index: Int, _ drinks: [Drink]) -> [Drink] {
        var drinks = drinks
        
        // Delete Images From Documents Folder
        if let imageID = drinks[index].imageId {
            ImageController.shared.deleteImage(imageID: imageID)
        }
        
        // Delete In Database
        do {
            // Delete Drink From Coredata
            if let drinkToDeleteId = drinks[index].drinkId {
                let drinkToDelete = managedContext.object(with: drinkToDeleteId)
                
                managedContext.delete(drinkToDelete)
                
                try managedContext.save()
            }
            
            // Remove drink from list
            drinks.remove(at: index)
        } catch let error as NSError {
            print("Could not delete: \(error)\n \(error.userInfo)")
        }
        
        return drinks
    }

}
