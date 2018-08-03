//
//  ModelController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/7/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation
import UIKit

class ModelController {
    static let shared = ModelController()
    
    private var drinks = [Drink]()
    
    private init() {
        let drink1 = Drink(image: UIImage(named: "Voss"), name: "Voss", favorite: true, category: 2, alcoholVolume: 0.0)
        let drink2 = Drink(image: nil, name: "Modelo", favorite: false, category: 1, alcoholVolume: 5.0)
        let drink3 = Drink(image: nil, name: "Stella Artois", favorite: true, category: 3, alcoholVolume: 4.4)
        
        drinks = [drink1, drink2, drink3]
    }
    
    func filterDrinks(category: Int) -> [Drink] {
        if category == 0 {
            return drinks
        } else {
            let filteredDrinks = drinks.filter { $0.category == category}
            return filteredDrinks
        }
    }
    
    func saveDrink(oldDrink: Drink?, newDrink: Drink) {
        if let oldDrink = oldDrink {
            let index = findDrink(drink: oldDrink)
            drinks[index] = newDrink
        } else {
            addDrink(drink: newDrink)
        }
    }
    
    func findDrink(drink: Drink) -> Int {
        if let index = drinks.index(where: {
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
    
    func addDrink(drink: Drink) {
        drinks += [drink]
    }
    
    func deleteDrink(drink: Drink) {
        let index = findDrink(drink: drink)
        drinks.remove(at: index)
    }
}
