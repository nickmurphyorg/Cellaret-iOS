//
//  ModelController.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/7/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation

class ModelController {
    private var drinks = [Drink]()
    
    init() {
        let drink1 = Drink(name: "Voss", favorite: true, category: 2, alcoholVolume: 0)
        let drink2 = Drink(name: "Modelo", favorite: false, category: 1, alcoholVolume: 5)
        
        drinks = [drink1, drink2]
    }
    
    func loadDrinks() -> [Drink] {
        return drinks
    }
    
    func filterDrinks(category: Int) -> [Drink] {
        if category == 0 {
            return drinks
        } else {
            let filteredDrinks = drinks.filter { $0.category == category}
            return filteredDrinks
        }
    }
    
    func saveDrink(drink: Drink, index: Int) {
        
    }
    
    func findDrink(drink: Drink) -> Int {
        if let index = drinks.index(where: {$0.name == drink.name}) {
            return index
        } else {
            return drinks.count + 1
        }
    }
    
    func addDrink(drink: Drink) {
        drinks += [drink]
    }
}
