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
    
    private var drinks = [Drink]()
    private var managedContext: NSManagedObjectContext!
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedContext = appDelegate.persistentContainer.viewContext
        
        let drinkRequest = NSFetchRequest<NSManagedObject>(entityName: "DrinkEntity")
        
        do {
            let returnedDrinks: [NSManagedObject] = try managedContext.fetch(drinkRequest)
            
            print("Database returned \(returnedDrinks.count) drinks.")
            
            for drink in returnedDrinks {
                let drinkObject = Drink.init(drinkEntity: drink)
                drinks.append(drinkObject)
            }
        } catch let error as NSError {
            print("Drinks could not be retrieved: \(error)\n \(error.userInfo).")
        }
    }
    
    func filterDrinks(category: Int) -> [Drink] {
        if category == 0 {
            return drinks
        } else {
            let filteredDrinks = drinks.filter { $0.category == category }
            return filteredDrinks
        }
    }
    
    func saveDrink(oldDrink: Drink?, newDrink: Drink) {
        
        guard let oldDrink = oldDrink else {
            addDrink(drink: newDrink)
            return
        }
        
        let index = findDrinkLocally(drink: oldDrink)
        let drinkManagedObject = findDrinkRemote(drink: oldDrink)
        let imageId: String? = newDrink.imageId != nil ? newDrink.imageId! : oldDrink.imageId
        
        drinks[index] = newDrink
        
        if let drinkManagedObject = drinkManagedObject {
            print("Managed object exists")
            
            drinkManagedObject.setValuesForKeys([
                "imageId": imageId as Any,
                "name": newDrink.name,
                "favorite": newDrink.favorite,
                "category": newDrink.category,
                "alcoholVolume": newDrink.alcoholVolume
            ])
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save: \(error)\n \(error.userInfo)")
            }
        } else {
            print("Managed object does not exist")
        }
        
        guard newDrink.imageId != nil else { return }
        
        if let oldImageId = oldDrink.imageId {
            ImageController.shared.deleteImage(imageID: oldImageId)
        }
    }
    
    func addDrink(drink: Drink) {
        drinks.append(drink)
        
        let entity = NSEntityDescription.entity(forEntityName: "DrinkEntity", in: managedContext)
        let drinkEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
        let imageId: String? = drink.imageId != nil ? drink.imageId! : nil
        
        drinkEntity.setValuesForKeys([
            "imageId": imageId as Any,
            "name": drink.name,
            "favorite": drink.favorite,
            "category": drink.category,
            "alcoholVolume": drink.alcoholVolume
        ])
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)\n \(error.userInfo)")
        }
    }
    
    func deleteDrink(drink: Drink) {
        let index = findDrinkLocally(drink: drink)
        let drinkToDelete = findDrinkRemote(drink: drink)
        
        // Delete Images From Documents Folder
        if let imageID = drink.imageId {
            ImageController.shared.deleteImage(imageID: imageID)
        }
        
        // Delete Locally
        drinks.remove(at: index)
        
        // Delete In Database
        do {
            if let drinkToDelete = drinkToDelete {
                managedContext.delete(drinkToDelete)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not delete: \(error)\n \(error.userInfo)")
        }
    }
    
    func findDrinkLocally(drink: Drink) -> Int {
        if let index = drinks.firstIndex(where: {
            $0.name == drink.name
                &&
                $0.category == drink.category
                &&
                $0.favorite == drink.favorite
        }) {
            return index
        } else {
            return drinks.count + 1
        }
    }
    
    func findDrinkRemote(drink: Drink) -> NSManagedObject? {
        let drinkFetch = NSFetchRequest<NSManagedObject>(entityName: "DrinkEntity")
        
        let namePredicate = NSPredicate(format:"name = %@", drink.name)
        let favoritePredicate = NSPredicate(format: "favorite = %@", NSNumber(value: drink.favorite))
        let categoryPredicate = NSPredicate(format: "category = %i", drink.category)
        let alcoholVolumePredicate = NSPredicate(format: "alcoholVolume = %e", drink.alcoholVolume)
        
        let filterDrinks = NSCompoundPredicate.init(andPredicateWithSubpredicates: [namePredicate, favoritePredicate, categoryPredicate, alcoholVolumePredicate])
        
        drinkFetch.predicate = filterDrinks
        drinkFetch.fetchLimit = 1
        
        do {
            let returnedDrinks: [NSManagedObject] = try managedContext.fetch(drinkFetch)
            return returnedDrinks.first
        } catch let error as NSError {
            print("Could not return the drink: \(error)\n \(error.userInfo)")
            return nil
        }
    }
}
