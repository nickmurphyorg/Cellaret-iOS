//
//  menuOptions.swift
//  Cellaret
//
//  Created by Nick Murphy on 7/5/18.
//  Copyright © 2018 Nick Murphy. All rights reserved.
//

import Foundation

struct Menu {
    static let shared = Menu()
    
    private let options: [String] = ["All", "American Whiskey", "Beer", "Bourbon", "Brandy", "Canadian Whiskey", "Energy Drink", "Gin", "Red Wine", "Rum", "Scotch", "Soda", "Tequila", "Water", "Whiskey", "White Wine", "Vodka"]
    
    func menuOptions() -> [String] {
        return options
    }
    
    func selectionName(selection: Int) -> String {
        let name = options[selection]
        return name
    }
    
    func categoryOptions() -> [String] {
        let categoryOptions = options.filter { $0 != "All" }
        return categoryOptions
    }
}
